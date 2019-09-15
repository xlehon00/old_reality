/**
 * Copyright (c) 2012 Anders Ekdahl (http://coffeescripter.com/)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version: 1.2.7
 *
 * Demo and documentation: http://coffeescripter.com/code/ad-gallery/
 */
(function($) {
  $.fn.adGallery = function(options) {
    var defaults = { loader_image: '../../gfx/lightbox/loader.gif',
                     start_at_index: 0,
                     update_window_hash: false,
                     description_wrapper: false,
                     thumb_opacity: 0.7,
                     animate_first_image: false,
                     animation_speed: 400,
                     width: false,
                     height: false,
                     display_next_and_prev: true,
                     display_back_and_forward: true,
                     scroll_jump: 0, // If 0, it jumps the width of the container
                     slideshow: {
                       enable: true,
                       autostart: false,
                       speed: 5000,
                       start_label: 'Start',
                       stop_label: 'Stop',
                       stop_on_scroll: true,
                       countdown_prefix: '(',
                       countdown_sufix: ')',
                       onStart: false,
                       onStop: false
                     },
                     effect: 'slide-hori', // or 'slide-vert', 'fade', or 'resize', 'none'
                     enable_keyboard_move: true,
                     cycle: true,
                     hooks: {
                       displayDescription: false
                     },
                     callbacks: {
                       init: false,
                       afterImageVisible: false,
                       beforeImageVisible: false
                     }
    };
    var settings = $.extend(false, defaults, options);
    if(options && options.slideshow) {
      settings.slideshow = $.extend(false, defaults.slideshow, options.slideshow);
    };
    if(!settings.slideshow.enable) {
      settings.slideshow.autostart = false;
    };
    var galleries = [];
    $(this).each(function() {
      var gallery = new AdGallery(this, settings);
      galleries[galleries.length] = gallery;
    });
    // Sorry, breaking the jQuery chain because the gallery instances
    // are returned so you can fiddle with them
    return galleries;
  };

  function VerticalSlideAnimation(img_container, direction, desc) {
    var current_top = parseInt(img_container.css('top'), 10);
    if(direction == 'left') {
      var old_image_top = '-'+ this.image_wrapper_height +'px';
      img_container.css('top', this.image_wrapper_height +'px');
    } else {
      var old_image_top = this.image_wrapper_height +'px';
      img_container.css('top', '-'+ this.image_wrapper_height +'px');
    };
    if(desc) {
      desc.css('bottom', '-'+ desc[0].offsetHeight +'px');
      desc.animate({bottom: 0}, this.settings.animation_speed * 2);
    };
    if(this.current_description) {
      this.current_description.animate({bottom: '-'+ this.current_description[0].offsetHeight +'px'}, this.settings.animation_speed * 2);
    };
    return {old_image: {top: old_image_top},
            new_image: {top: current_top}};
  };

  function HorizontalSlideAnimation(img_container, direction, desc) {
    var current_left = parseInt(img_container.css('left'), 10);
    if(direction == 'left') {
      var old_image_left = '-'+ this.image_wrapper_width +'px';
      img_container.css('left',this.image_wrapper_width +'px');
    } else {
      var old_image_left = this.image_wrapper_width +'px';
      img_container.css('left','-'+ this.image_wrapper_width +'px');
    };
    if(desc) {
      desc.css('bottom', '-'+ desc[0].offsetHeight +'px');
      desc.animate({bottom: 0}, this.settings.animation_speed * 2);
    };
    if(this.current_description) {
      this.current_description.animate({bottom: '-'+ this.current_description[0].offsetHeight +'px'}, this.settings.animation_speed * 2);
    };
    return {old_image: {left: old_image_left},
            new_image: {left: current_left}};
  };

  function ResizeAnimation(img_container, direction, desc) {
    var image_width = img_container.width();
    var image_height = img_container.height();
    var current_left = parseInt(img_container.css('left'), 10);
    var current_top = parseInt(img_container.css('top'), 10);
    img_container.css({width: 0, height: 0, top: this.image_wrapper_height / 2, left: this.image_wrapper_width / 2});
    return {old_image: {width: 0,
                        height: 0,
                        top: this.image_wrapper_height / 2,
                        left: this.image_wrapper_width / 2},
            new_image: {width: image_width,
                        height: image_height,
                        top: current_top,
                        left: current_left}};
  };

  function FadeAnimation(img_container, direction, desc) {
    img_container.css('opacity', 0);
    return {old_image: {opacity: 0},
            new_image: {opacity: 1}};
  };

  // Sort of a hack, will clean this up... eventually
  function NoneAnimation(img_container, direction, desc) {
    img_container.css('opacity', 0);
    return {old_image: {opacity: 0},
            new_image: {opacity: 1},
            speed: 0};
  };

  function AdGallery(wrapper, settings) {
    this.init(wrapper, settings);
  };
  AdGallery.prototype = {
    // Elements
    wrapper: false,
    image_wrapper: false,
    gallery_info: false,
    nav: false,
    loader: false,
    preloads: false,
    thumbs_wrapper: false,
    thumbs_wrapper_width: 0,
    scroll_back: false,
    scroll_forward: false,
    next_link: false,
    prev_link: false,

    slideshow: false,
    image_wrapper_width: 0,
    image_wrapper_height: 0,
    current_index: -1,
    current_image: false,
    current_description: false,
    nav_display_width: 0,
    settings: false,
    images: false,
    in_transition: false,
    animations: false,
    init: function(wrapper, settings) {
      var context = this;
      this.wrapper = $(wrapper);
      this.settings = settings;
      this.setupElements();
      this.setupAnimations();
      if(this.settings.width) {
        this.image_wrapper_width = this.settings.width;
        this.image_wrapper.width(this.settings.width);
        this.wrapper.width(this.settings.width);
      } else {
        this.image_wrapper_width = this.image_wrapper.width();
      };
      if(this.settings.height) {
        this.image_wrapper_height = this.settings.height;
        this.image_wrapper.height(this.settings.height);
      } else {
        this.image_wrapper_height = this.image_wrapper.height();
      };
      this.nav_display_width = this.nav.width();
      this.current_index = -1;
      this.current_image = false;
      this.current_description = false;
      this.in_transition = false;
      this.findImages();
      if(this.settings.display_next_and_prev) {
        this.initNextAndPrev();
      };
      // The slideshow needs a callback to trigger the next image to be shown
      // but we don't want to give it access to the whole gallery instance
      var nextimage_callback = function(callback) {
        return context.nextImage(callback);
      };
      this.slideshow = new AdGallerySlideshow(nextimage_callback, this.settings.slideshow);
      this.controls.append(this.slideshow.create());
      if(this.settings.slideshow.enable) {
        this.slideshow.enable();
      } else {
        this.slideshow.disable();
      };
      if(this.settings.display_back_and_forward) {
        this.initBackAndForward();
      };
      if(this.settings.enable_keyboard_move) {
        this.initKeyEvents();
      };
      this.initHashChange();
      var start_at = parseInt(this.settings.start_at_index, 10);
      if(typeof this.getIndexFromHash() != "undefined") {
        start_at = this.getIndexFromHash();
      };
      this.loading(true);
      this.showImage(start_at,
        function() {
          // We don't want to start the slideshow before the image has been
          // displayed
          if(context.settings.slideshow.autostart) {
            context.preloadImage(start_at + 1);
            context.slideshow.start();
          };
        }
      );
      this.fireCallback(this.settings.callbacks.init);
    },
    setupAnimations: function() {
      this.animations = {
        'slide-vert': VerticalSlideAnimation,
        'slide-hori': HorizontalSlideAnimation,
        'resize': ResizeAnimation,
        'fade': FadeAnimation,
        'none': NoneAnimation
      };
    },
    setupElements: function() {
      this.controls = this.wrapper.find('.ad-controls');
      this.gallery_info = $('<p class="ad-info"></p>');
      this.controls.append(this.gallery_info);
      this.image_wrapper = this.wrapper.find('.ad-image-wrapper');
      this.image_wrapper.empty();
      this.nav = this.wrapper.find('.ad-nav');
      this.thumbs_wrapper = this.nav.find('.ad-thumbs');
      this.preloads = $('<div class="ad-preloads"></div>');
      this.loader = $('<img class="ad-loader" src="'+ this.settings.loader_image +'">');
      this.image_wrapper.append(this.loader);
      this.loader.hide();
      $(document.body).append(this.preloads);
    },
    loading: function(bool) {
      if(bool) {
        this.loader.show();
      } else {
        this.loader.hide();
      };
    },
    addAnimation: function(name, fn) {
      if($.isFunction(fn)) {
        this.animations[name] = fn;
      };
    },
    findImages: function() {
      var context = this;
      this.images = [];
      var thumbs_loaded = 0;
      var thumbs = this.thumbs_wrapper.find('a');
      var thumb_count = thumbs.length;
      if(this.settings.thumb_opacity < 1) {
        thumbs.find('img').css('opacity', this.settings.thumb_opacity);
      };
      thumbs.each(
        function(i) {
          var link = $(this);
          link.data("ad-i", i);
          var image_src = link.attr('href');
          var thumb = link.find('img');
          context.whenImageLoaded(thumb[0], function() {
            var width = thumb[0].parentNode.parentNode.offsetWidth;
            if(thumb[0].width == 0) {
              // If the browser tells us that the image is loaded, but the width
              // is still 0 for some reason, we default to 100px width.
              // It's not very nice, but it's better than 0.
              width = 100;
            };
            context.thumbs_wrapper_width += width;
            thumbs_loaded++;
          });
          context._initLink(link);
          context.images[i] = context._createImageData(link, image_src);
        }
      );
      // Wait until all thumbs are loaded, and then set the width of the ul
      var inter = setInterval(
        function() {
          if(thumb_count == thumbs_loaded) {
            context._setThumbListWidth(context.thumbs_wrapper_width);
            clearInterval(inter);
          };
        },
        100
      );
    },
    _setThumbListWidth: function(wrapper_width) {
      wrapper_width -= 100;
      var list = this.nav.find('.ad-thumb-list');
      list.css('width', wrapper_width +'px');
      var i = 1;
      var last_height = list.height();
      while(i < 201) {
        list.css('width', (wrapper_width + i) +'px');
        if(last_height != list.height()) {
          break;
        };
        last_height = list.height();
        i++;
      };
      if(list.width() < this.nav.width()) {
        list.width(this.nav.width());
      };
    },
    _initLink: function(link) {
      var context = this;
      link.click(
        function() {
          context.showImage(link.data("ad-i"));
          context.slideshow.stop();
          return false;
        }
      ).hover(
        function() {
          if(!$(this).is('.ad-active') && context.settings.thumb_opacity < 1) {
            $(this).find('img').fadeTo(300, 1);
          };
          context.preloadImage(link.data("ad-i"));
        },
        function() {
          if(!$(this).is('.ad-active') && context.settings.thumb_opacity < 1) {
            $(this).find('img').fadeTo(300, context.settings.thumb_opacity);
          };
        }
      );
    },
    _createImageData: function(thumb_link, image_src) {
      var link = false;
      var thumb_img = thumb_link.find("img");
      if(thumb_img.data('ad-link')) {
        link = thumb_link.data('ad-link');
      } else if(thumb_img.attr('longdesc') && thumb_img.attr('longdesc').length) {
        link = thumb_img.attr('longdesc');
      };
      var desc = false;
      if(thumb_img.data('ad-desc')) {
        desc = thumb_img.data('ad-desc');
      } else if(thumb_img.attr('alt') && thumb_img.attr('alt').length) {
        desc = thumb_img.attr('alt');
      };
      var title = false;
      if(thumb_img.data('ad-title')) {
        title = thumb_img.data('ad-title');
      } else if(thumb_img.attr('title') && thumb_img.attr('title').length) {
        title = thumb_img.attr('title');
      };
      return { thumb_link: thumb_link, image: image_src, error: false,
               preloaded: false, desc: desc, title: title, size: false,
               link: link };
    },
    initKeyEvents: function() {
      var context = this;
      $(document).keydown(
        function(e) {
          if(e.keyCode == 39) {
            // right arrow
            context.nextImage();
            context.slideshow.stop();
          } else if(e.keyCode == 37) {
            // left arrow
            context.prevImage();
            context.slideshow.stop();
          };
        }
      );
    },
    getIndexFromHash: function() {
      if(window.location.hash && window.location.hash.indexOf('#ad-image-') === 0) {
        var id = window.location.hash.replace(/^#ad-image-/g, '');
        var thumb = this.thumbs_wrapper.find("#"+ id);
        if(thumb.length) {
          return this.thumbs_wrapper.find("a").index(thumb);
        } else if(!isNaN(parseInt(id, 10))) {
          return parseInt(id, 10);
        };
      };
      return undefined;
    },
    removeImage: function(index) {
      if(index < 0 || index >= this.images.length) {
        throw "Cannot remove image for index "+ index;
      };
      var image = this.images[index];
      this.images.splice(index, 1);
      var thumb_link = image.thumb_link;
      var thumb_width = thumb_link[0].parentNode.offsetWidth;
      this.thumbs_wrapper_width -= thumb_width;
      thumb_link.remove();
      this._setThumbListWidth(this.thumbs_wrapper_width);
      this.gallery_info.html((this.current_index + 1) +' / '+ this.images.length);
      this.thumbs_wrapper.find('a').each(
        function(i) {
          $(this).data("ad-i", i);
        }
      );
      if(index == this.current_index && this.images.length != 0) {
        this.showImage(0);
      };
    },
    removeAllImages: function() {
      for (var i = this.images.length - 1; i >= 0; i--) {
        this.removeImage(i);
      };
    },
    addImage: function(thumb_url, image_url, image_id, title, description) {
      image_id = image_id || "";
      title = title || "";
      description = description || "";
      var li = $('<li><a href="'+ image_url +'" id="'+ image_id +'">' +
                   '<img src="'+ thumb_url +'" title="'+ title +'" alt="'+ description +'">' +
                 '</a></li>');
      var context = this;
      this.thumbs_wrapper.find("ul").append(li);
      
      var link = li.find("a");
      var thumb = link.find("img");
      thumb.css('opacity', this.settings.thumb_opacity);
      
      this.whenImageLoaded(thumb[0], function() {
        var thumb_width = thumb[0].parentNode.parentNode.offsetWidth;
        if(thumb[0].width == 0) {
          // If the browser tells us that the image is loaded, but the width
          // is still 0 for some reason, we default to 100px width.
          // It's not very nice, but it's better than 0.
          thumb_width = 100;
        };
        
        context.thumbs_wrapper_width += thumb_width;
        context._setThumbListWidth(context.thumbs_wrapper_width);
      });
      var i = this.images.length;
      link.data("ad-i", i);
      this._initLink(link);
      this.images[i] = context._createImageData(link, image_url);
      this.gallery_info.html((this.current_index + 1) +' / '+ this.images.length);
    },
    initHashChange: function() {
      var context = this;
      if("onhashchange" in window) {
        $(window).bind("hashchange", function() {
          var index = context.getIndexFromHash();
          if(typeof index != "undefined" && index != context.current_index) {
            context.showImage(index);
          };
        });
      } else {
        var current_hash = window.location.hash;
        setInterval(function() {
          if(window.location.hash != current_hash) {
            current_hash = window.location.hash;
            var index = context.getIndexFromHash();
            if(typeof index != "undefined" && index != context.current_index) {
              context.showImage(index);
            };
          };
        }, 200);
      };
    },
    initNextAndPrev: function() {
      this.next_link = $('<div class="ad-next"><div class="ad-next-image"></div></div>');
      this.prev_link = $('<div class="ad-prev"><div class="ad-prev-image"></div></div>');
      this.image_wrapper.append(this.next_link);
      this.image_wrapper.append(this.prev_link);
      var context = this;
      this.prev_link.add(this.next_link).mouseover(
        function(e) {
          // IE 6 hides the wrapper div, so we have to set it's width
          $(this).css('height', context.image_wrapper_height);
          $(this).find('div').show();
        }
      ).mouseout(
        function(e) {
          $(this).find('div').hide();
        }
      ).click(
        function() {
          if($(this).is('.ad-next')) {
            context.nextImage();
            context.slideshow.stop();
          } else {
            context.prevImage();
            context.slideshow.stop();
          };
        }
      ).find('div').css('opacity', 0.7);
    },
    initBackAndForward: function() {
      var context = this;
      this.scroll_forward = $('<div class="ad-forward"></div>');
      this.scroll_back = $('<div class="ad-back"></div>');
      this.nav.append(this.scroll_forward);
      this.nav.prepend(this.scroll_back);
      var has_scrolled = 0;
      var thumbs_scroll_interval = false;
      $(this.scroll_back).add(this.scroll_forward).click(
        function() {
          // We don't want to jump the whole width, since an image
          // might be cut at the edge
          var width = context.nav_display_width - 50;
          if(context.settings.scroll_jump > 0) {
            var width = context.settings.scroll_jump;
          };
          if($(this).is('.ad-forward')) {
            var left = context.thumbs_wrapper.scrollLeft() + width;
          } else {
            var left = context.thumbs_wrapper.scrollLeft() - width;
          };
          if(context.settings.slideshow.stop_on_scroll) {
            context.slideshow.stop();
          };
          context.thumbs_wrapper.animate({scrollLeft: left +'px'});
          return false;
        }
      ).css('opacity', 0.6).hover(
        function() {
          var direction = 'left';
          if($(this).is('.ad-forward')) {
            direction = 'right';
          };
          thumbs_scroll_interval = setInterval(
            function() {
              has_scrolled++;
              // Don't want to stop the slideshow just because we scrolled a pixel or two
              if(has_scrolled > 30 && context.settings.slideshow.stop_on_scroll) {
                context.slideshow.stop();
              };
              var left = context.thumbs_wrapper.scrollLeft() + 1;
              if(direction == 'left') {
                left = context.thumbs_wrapper.scrollLeft() - 1;
              };
              context.thumbs_wrapper.scrollLeft(left);
            },
            10
          );
          $(this).css('opacity', 1);
        },
        function() {
          has_scrolled = 0;
          clearInterval(thumbs_scroll_interval);
          $(this).css('opacity', 0.6);
        }
      );
    },
    _afterShow: function() {
      this.gallery_info.html((this.current_index + 1) +' / '+ this.images.length);
      if(!this.settings.cycle) {
        // Needed for IE
        this.prev_link.show().css('height', this.image_wrapper_height);
        this.next_link.show().css('height', this.image_wrapper_height);
        if(this.current_index == (this.images.length - 1)) {
          this.next_link.hide();
        };
        if(this.current_index == 0) {
          this.prev_link.hide();
        };
      };
      if(this.settings.update_window_hash) {
        var thumb_link = this.images[this.current_index].thumb_link;
        if (thumb_link.attr("id")) {
          window.location.hash = "#ad-image-"+ thumb_link.attr("id");
        } else {
          window.location.hash = "#ad-image-"+ this.current_index;
        };
      };
      this.fireCallback(this.settings.callbacks.afterImageVisible);
    },
    /**
     * Checks if the image is small enough to fit inside the container
     * If it's not, shrink it proportionally
     */
    _getContainedImageSize: function(image_width, image_height) {
      if(image_height > this.image_wrapper_height) {
        var ratio = image_width / image_height;
        image_height = this.image_wrapper_height;
        image_width = this.image_wrapper_height * ratio;
      };
      if(image_width > this.image_wrapper_width) {
  	    var ratio = image_height / image_width;
  	    image_width = this.image_wrapper_width;
  	    image_height = this.image_wrapper_width * ratio;
  	  };
      return {width: image_width, height: image_height};
    },
    /**
     * If the image dimensions are smaller than the wrapper, we position
     * it in the middle anyway
     */
    _centerImage: function(img_container, image_width, image_height) {
      img_container.css('top', '0px');
      if(image_height < this.image_wrapper_height) {
        var dif = this.image_wrapper_height - image_height;
        img_container.css('top', (dif / 2) +'px');
      };
      img_container.css('left', '0px');
      if(image_width < this.image_wrapper_width) {
        var dif = this.image_wrapper_width - image_width;
        img_container.css('left', (dif / 2) +'px');
      };
    },
    _getDescription: function(image) {
      var desc = false;
      if(image.desc.length || image.title.length) {
        var title = '';
        if(image.title.length) {
          title = '<strong class="ad-description-title">'+ image.title +'</strong>';
        };
        var desc = '';
        if(image.desc.length) {
          desc = '<span>'+ image.desc +'</span>';
        };
        desc = $('<p class="ad-image-description">'+ title + desc +'</p>');
      };
      return desc;
    },
    /**
     * @param function callback Gets fired when the image has loaded, is displaying
     *                          and it's animation has finished
     */
    showImage: function(index, callback) {
      if(this.images[index] && !this.in_transition && index != this.current_index) {
        var context = this;
        var image = this.images[index];
        this.in_transition = true;
        if(!image.preloaded) {
          this.loading(true);
          this.preloadImage(index, function() {
            context.loading(false);
            context._showWhenLoaded(index, callback);
          });
        } else {
          this._showWhenLoaded(index, callback);
        };
      };
    },
    /**
     * @param function callback Gets fired when the image has loaded, is displaying
     *                          and it's animation has finished
     */
    _showWhenLoaded: function(index, callback) {
      if(this.images[index]) {
        var context = this;
        var image = this.images[index];
        var img_container = $(document.createElement('div')).addClass('ad-image');
        var img = $(new Image()).attr('src', image.image);
		  if (image.desc) {
		  	img.attr('alt', image.desc);
		  }
        if(image.link) {
          var link = $('<a href="'+ image.link +'" rel="prettyPhoto[detailGallery]"></a>');
          link.append(img);
          img_container.append(link);
        } else {
          img_container.append(img);
        };
        this.image_wrapper.prepend(img_container);
		  $("a[rel^='prettyPhoto']").prettyPhoto();
		  if (image.size.height == 0) {
			  image.size.height = 'auto';
		  }
        var size = this._getContainedImageSize(image.size.width, image.size.height);
        img.attr('width', size.width);
        img.attr('height', size.height);
        img_container.css({width: size.width +'px', height: size.height +'px'});
        this._centerImage(img_container, size.width, size.height);
        var desc = this._getDescription(image);
        if(desc) {
          if(!this.settings.description_wrapper && !this.settings.hooks.displayDescription) {
            img_container.append(desc);
            var width = size.width - parseInt(desc.css('padding-left'), 10) - parseInt(desc.css('padding-right'), 10);
            desc.css('width', width +'px');
          } else if(this.settings.hooks.displayDescription) {
            this.settings.hooks.displayDescription.call(this, image);
          } else {
            var wrapper = this.settings.description_wrapper;
            wrapper.append(desc);
          };
        };
        this.highLightThumb(this.images[index].thumb_link);
        
        var direction = 'right';
        if(this.current_index < index) {
          direction = 'left';
        };
        this.fireCallback(this.settings.callbacks.beforeImageVisible);
        if(this.current_image || this.settings.animate_first_image) {
          var animation_speed = this.settings.animation_speed;
          var easing = 'swing';
          var animation = this.animations[this.settings.effect].call(this, img_container, direction, desc);
          if(typeof animation.speed != 'undefined') {
            animation_speed = animation.speed;
          };
          if(typeof animation.easing != 'undefined') {
            easing = animation.easing;
          };
          if(this.current_image) {
            var old_image = this.current_image;
            var old_description = this.current_description;
            old_image.animate(animation.old_image, animation_speed, easing,
              function() {
                old_image.remove();
                if(old_description) old_description.remove();
              }
            );
          };
          img_container.animate(animation.new_image, animation_speed, easing,
            function() {
              context.current_index = index;
              context.current_image = img_container;
              context.current_description = desc;
              context.in_transition = false;
              context._afterShow();
              context.fireCallback(callback);
            }
          );
        } else {
          this.current_index = index;
          this.current_image = img_container;
          context.current_description = desc;
          this.in_transition = false;
          context._afterShow();
          this.fireCallback(callback);
        };
      };
    },
    nextIndex: function() {
      if(this.current_index == (this.images.length - 1)) {
        if(!this.settings.cycle) {
          return false;
        };
        var next = 0;
      } else {
        var next = this.current_index + 1;
      };
      return next;
    },
    nextImage: function(callback) {
      var next = this.nextIndex();
      if(next === false) return false;
      this.preloadImage(next + 1);
      this.showImage(next, callback);
      return true;
    },
    prevIndex: function() {
      if(this.current_index == 0) {
        if(!this.settings.cycle) {
          return false;
        };
        var prev = this.images.length - 1;
      } else {
        var prev = this.current_index - 1;
      };
      return prev;
    },
    prevImage: function(callback) {
      var prev = this.prevIndex();
      if(prev === false) return false;
      this.preloadImage(prev - 1);
      this.showImage(prev, callback);
      return true;
    },
    preloadAll: function() {
      var context = this;
      var i = 0;
      function preloadNext() {
        if(i < context.images.length) {
          i++;
          context.preloadImage(i, preloadNext);
        };
      };
      context.preloadImage(i, preloadNext);
    },
    preloadImage: function(index, callback) {
      if(this.images[index]) {
        var image = this.images[index];
        if(!this.images[index].preloaded) {
          var img = $(new Image());
          img.attr('src', image.image);
          if(!this.isImageLoaded(img[0])) {
            this.preloads.append(img);
            var context = this;
            img.load(
              function() {
                image.preloaded = true;
                image.size = { width: this.width, height: this.height };
                context.fireCallback(callback);
              }
            ).error(
              function() {
                image.error = true;
                image.preloaded = false;
                image.size = false;
              }
            );
          } else {
            image.preloaded = true;
            image.size = { width: img[0].width, height: img[0].height };
            this.fireCallback(callback);
          };
        } else {
          this.fireCallback(callback);
        };
      };
    },
    whenImageLoaded: function(img, callback) {
      if (this.isImageLoaded(img)) {
        callback && callback();
      } else {
        $(img).load(callback);
      };
    },
    isImageLoaded: function(img) {
      if(typeof img.complete != 'undefined' && !img.complete) {
        return false;
      };
      if(typeof img.naturalWidth != 'undefined' && img.naturalWidth == 0) {
        return false;
      };
      return true;
    },
    highLightThumb: function(thumb) {
      this.thumbs_wrapper.find('.ad-active').removeClass('ad-active');
      thumb.addClass('ad-active');
      if(this.settings.thumb_opacity < 1) {
        this.thumbs_wrapper.find('a:not(.ad-active) img').fadeTo(300, this.settings.thumb_opacity);
        thumb.find('img').fadeTo(300, 1);
      };
      var left = thumb[0].parentNode.offsetLeft;
      left -= (this.nav_display_width / 2) - (thumb[0].offsetWidth / 2);
      this.thumbs_wrapper.animate({scrollLeft: left +'px'});
    },
    fireCallback: function(fn) {
      if($.isFunction(fn)) {
        fn.call(this);
      };
    }
  };

  function AdGallerySlideshow(nextimage_callback, settings) {
    this.init(nextimage_callback, settings);
  };
  AdGallerySlideshow.prototype = {
    start_link: false,
    stop_link: false,
    countdown: false,
    controls: false,

    settings: false,
    nextimage_callback: false,
    enabled: false,
    running: false,
    countdown_interval: false,
    init: function(nextimage_callback, settings) {
      var context = this;
      this.nextimage_callback = nextimage_callback;
      this.settings = settings;
    },
    create: function() {
      this.start_link = $('<span class="ad-slideshow-start">'+ this.settings.start_label +'</span>');
      this.stop_link = $('<span class="ad-slideshow-stop">'+ this.settings.stop_label +'</span>');
      this.countdown = $('<span class="ad-slideshow-countdown"></span>');
      this.controls = $('<div class="ad-slideshow-controls"></div>');
      this.controls.append(this.start_link).append(this.stop_link).append(this.countdown);
      this.countdown.hide();

      var context = this;
      this.start_link.click(
        function() {
          context.start();
        }
      );
      this.stop_link.click(
        function() {
          context.stop();
        }
      );
      $(document).keydown(
        function(e) {
          if(e.keyCode == 83) {
            // 's'
            if(context.running) {
              context.stop();
            } else {
              context.start();
            };
          };
        }
      );
      return this.controls;
    },
    disable: function() {
      this.enabled = false;
      this.stop();
      this.controls.hide();
    },
    enable: function() {
      this.enabled = true;
      this.controls.show();
    },
    toggle: function() {
      if(this.enabled) {
        this.disable();
      } else {
        this.enable();
      };
    },
    start: function() {
      if(this.running || !this.enabled) return false;
      var context = this;
      this.running = true;
      this.controls.addClass('ad-slideshow-running');
      this._next();
      this.fireCallback(this.settings.onStart);
      return true;
    },
    stop: function() {
      if(!this.running) return false;
      this.running = false;
      this.countdown.hide();
      this.controls.removeClass('ad-slideshow-running');
      clearInterval(this.countdown_interval);
      this.fireCallback(this.settings.onStop);
      return true;
    },
    _next: function() {
      var context = this;
      var pre = this.settings.countdown_prefix;
      var su = this.settings.countdown_sufix;
      clearInterval(context.countdown_interval);
      this.countdown.show().html(pre + (this.settings.speed / 1000) + su);
      var slide_timer = 0;
      this.countdown_interval = setInterval(
        function() {
          slide_timer += 1000;
          if(slide_timer >= context.settings.speed) {
            var whenNextIsShown = function() {
              // A check so the user hasn't stoped the slideshow during the
              // animation
              if(context.running) {
                context._next();
              };
              slide_timer = 0;
            };
            if(!context.nextimage_callback(whenNextIsShown)) {
              context.stop();
            };
            slide_timer = 0;
          };
          var sec = parseInt(context.countdown.text().replace(/[^0-9]/g, ''), 10);
          sec--;
          if(sec > 0) {
            context.countdown.html(pre + sec + su);
          };
        },
        1000
      );
    },
    fireCallback: function(fn) {
      if($.isFunction(fn)) {
        fn.call(this);
      };
    }
  };
})(jQuery);
/*!
 * The Final Countdown for jQuery v2.1.0 (http://hilios.github.io/jQuery.countdown/)
 * Copyright (c) 2015 Edson Hilios
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
(function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
        define([ "jquery" ], factory);
    } else {
        factory(jQuery);
    }
})(function($) {
    "use strict";
    var instances = [], matchers = [], defaultOptions = {
        precision: 100,
        elapse: false
    };
    matchers.push(/^[0-9]*$/.source);
    matchers.push(/([0-9]{1,2}\/){2}[0-9]{4}( [0-9]{1,2}(:[0-9]{2}){2})?/.source);
    matchers.push(/[0-9]{4}([\/\-][0-9]{1,2}){2}( [0-9]{1,2}(:[0-9]{2}){2})?/.source);
    matchers = new RegExp(matchers.join("|"));
    function parseDateString(dateString) {
        if (dateString instanceof Date) {
            return dateString;
        }
        if (String(dateString).match(matchers)) {
            if (String(dateString).match(/^[0-9]*$/)) {
                dateString = Number(dateString);
            }
            if (String(dateString).match(/\-/)) {
                dateString = String(dateString).replace(/\-/g, "/");
            }
            return new Date(dateString);
        } else {
            throw new Error("Couldn't cast `" + dateString + "` to a date object.");
        }
    }
    var DIRECTIVE_KEY_MAP = {
        Y: "years",
        m: "months",
        n: "daysToMonth",
        w: "weeks",
        d: "daysToWeek",
        D: "totalDays",
        H: "hours",
        M: "minutes",
        S: "seconds"
    };
    function escapedRegExp(str) {
        var sanitize = str.toString().replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1");
        return new RegExp(sanitize);
    }
    function strftime(offsetObject) {
        return function(format) {
            var directives = format.match(/%(-|!)?[A-Z]{1}(:[^;]+;)?/gi);
            if (directives) {
                for (var i = 0, len = directives.length; i < len; ++i) {
                    var directive = directives[i].match(/%(-|!)?([a-zA-Z]{1})(:[^;]+;)?/), regexp = escapedRegExp(directive[0]), modifier = directive[1] || "", plural = directive[3] || "", value = null;
                    directive = directive[2];
                    if (DIRECTIVE_KEY_MAP.hasOwnProperty(directive)) {
                        value = DIRECTIVE_KEY_MAP[directive];
                        value = Number(offsetObject[value]);
                    }
                    if (value !== null) {
                        if (modifier === "!") {
                            value = pluralize(plural, value);
                        }
                        if (modifier === "") {
                            if (value < 10) {
                                value = "0" + value.toString();
                            }
                        }
                        format = format.replace(regexp, value.toString());
                    }
                }
            }
            format = format.replace(/%%/, "%");
            return format;
        };
    }
    function pluralize(format, count) {
        var plural = "s", singular = "";
        if (format) {
            format = format.replace(/(:|;|\s)/gi, "").split(/\,/);
            if (format.length === 1) {
                plural = format[0];
            } else {
                singular = format[0];
                plural = format[1];
            }
        }
        if (Math.abs(count) === 1) {
            return singular;
        } else {
            return plural;
        }
    }
    var Countdown = function(el, finalDate, options) {
        this.el = el;
        this.$el = $(el);
        this.interval = null;
        this.offset = {};
        this.options = $.extend({}, defaultOptions);
        this.instanceNumber = instances.length;
        instances.push(this);
        this.$el.data("countdown-instance", this.instanceNumber);
        if (options) {
            if (typeof options === "function") {
                this.$el.on("update.countdown", options);
                this.$el.on("stoped.countdown", options);
                this.$el.on("finish.countdown", options);
            } else {
                this.options = $.extend({}, defaultOptions, options);
            }
        }
        this.setFinalDate(finalDate);
        this.start();
    };
    $.extend(Countdown.prototype, {
        start: function() {
            if (this.interval !== null) {
                clearInterval(this.interval);
            }
            var self = this;
            this.update();
            this.interval = setInterval(function() {
                self.update.call(self);
            }, this.options.precision);
        },
        stop: function() {
            clearInterval(this.interval);
            this.interval = null;
            this.dispatchEvent("stoped");
        },
        toggle: function() {
            if (this.interval) {
                this.stop();
            } else {
                this.start();
            }
        },
        pause: function() {
            this.stop();
        },
        resume: function() {
            this.start();
        },
        remove: function() {
            this.stop.call(this);
            instances[this.instanceNumber] = null;
            delete this.$el.data().countdownInstance;
        },
        setFinalDate: function(value) {
            this.finalDate = parseDateString(value);
        },
        update: function() {
            if (this.$el.closest("html").length === 0) {
                this.remove();
                return;
            }
            var hasEventsAttached = $._data(this.el, "events") !== undefined, now = new Date(), newTotalSecsLeft;
            newTotalSecsLeft = this.finalDate.getTime() - now.getTime();
            newTotalSecsLeft = Math.ceil(newTotalSecsLeft / 1e3);
            newTotalSecsLeft = !this.options.elapse && newTotalSecsLeft < 0 ? 0 : Math.abs(newTotalSecsLeft);
            if (this.totalSecsLeft === newTotalSecsLeft || !hasEventsAttached) {
                return;
            } else {
                this.totalSecsLeft = newTotalSecsLeft;
            }
            this.elapsed = now >= this.finalDate;
            this.offset = {
                seconds: this.totalSecsLeft % 60,
                minutes: Math.floor(this.totalSecsLeft / 60) % 60,
                hours: Math.floor(this.totalSecsLeft / 60 / 60) % 24,
                days: Math.floor(this.totalSecsLeft / 60 / 60 / 24) % 7,
                daysToWeek: Math.floor(this.totalSecsLeft / 60 / 60 / 24) % 7,
                daysToMonth: Math.floor(this.totalSecsLeft / 60 / 60 / 24 % 30.4368),
                totalDays: Math.floor(this.totalSecsLeft / 60 / 60 / 24),
                weeks: Math.floor(this.totalSecsLeft / 60 / 60 / 24 / 7),
                months: Math.floor(this.totalSecsLeft / 60 / 60 / 24 / 30.4368),
                years: Math.abs(this.finalDate.getFullYear() - now.getFullYear())
            };
            if (!this.options.elapse && this.totalSecsLeft === 0) {
                this.stop();
                this.dispatchEvent("finish");
            } else {
                this.dispatchEvent("update");
            }
        },
        dispatchEvent: function(eventName) {
            var event = $.Event(eventName + ".countdown");
            event.finalDate = this.finalDate;
            event.elapsed = this.elapsed;
            event.offset = $.extend({}, this.offset);
            event.strftime = strftime(this.offset);
            this.$el.trigger(event);
        }
    });
    $.fn.countdown = function() {
        var argumentsArray = Array.prototype.slice.call(arguments, 0);
        return this.each(function() {
            var instanceNumber = $(this).data("countdown-instance");
            if (instanceNumber !== undefined) {
                var instance = instances[instanceNumber], method = argumentsArray[0];
                if (Countdown.prototype.hasOwnProperty(method)) {
                    instance[method].apply(instance, argumentsArray.slice(1));
                } else if (String(method).match(/^[$A-Z_][0-9A-Z_$]*$/i) === null) {
                    instance.setFinalDate.call(instance, method);
                    instance.start();
                } else {
                    $.error("Method %s does not exist on jQuery.countdown".replace(/\%s/gi, method));
                }
            } else {
                new Countdown(this, argumentsArray[0], argumentsArray[1]);
            }
        });
    };
});
$(function() {
	if ($('.top-navs').length) {
		var hash = window.location.hash;
		if (hash == '#contact-places') {
			$('.top-navs li.contact-places a').tab('show');
		} else {
			$('.top-navs li:first-child a').tab('show');
		}
		topDetailNav();
		if (hash == '#broker-info') {
			$('.top-navs li.broker-info-tab a').tab('show');
		}
	}

	var galleryContainer = $('.ad-gallery');
	galleryContainer.adGallery({'loader_image': galleryContainer.attr('data-loader-image')});
  $('#img_0').parent().click();
	$("a[rel^='prettyPhoto']").prettyPhoto({
    autoplay: true
	});
	Dalten.Form.Ajax.start();

	$('#share-email, #send-selected-listing-list').click(function() {
		var element = $(this), target = $(element.attr('data-target-element')), url = element.attr('data-target-url');
		if (element.hasClass('disabled')) return false;
		var handler = function handler(content) {
			target.html(content);
			Dalten.Form.Ajax.start(target);
			target.show();
			Dalten.Tool.Tool.scrollToElement(target);
		};
		$.get(url, [] , handler, 'html');

		return false;
	});

	$('#similar-listings-need-help').click(function() {
		$('#basic-info-tab').click();
		$('html, body').animate({ scrollTop: $('#main-broker-info').offset().top }, 500);

		return false;
	});

	$(function() {
		var target = $('#contact-form-container'), url = target.attr('data-target-url');
		var handler = function handler(content) {
			target.html(content);
			Dalten.Form.Ajax.start(target, {'afterFormReload': function() {
				var successData = target.find('#contact-form-success');
				if (successData.length == 1) {
					dataLayer.push({
						'event': 'orderID',
						'value': successData.attr('data-price'),
						'orderId': successData.attr('data-form-id'),
						'deduplication': 'true',
						'RTBHID': successData.attr('data-listing-id')
					});
				}
			}});
		};
		$.get(url, [] , handler, 'html');

		return false;
	});

	$('#order-openhouse').click(function () {
		$('#dalten_web_listing_contact_form_interested_in_tour').click();
		Dalten.Tool.Tool.scrollToElement($('#main-broker-info'));

		return false;
	});

	$('.social-icons .fb-icon').click(function() {
		return !window.open(this.href, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=250,width=600');
	});

	$('.social-icons .google-icon').click(function() {
		return !window.open(this.href, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
	});

	$('.social-icons .print-icon').click(function() {
		window.print();
		return false;
	});

	$('#more-info').click(function() {
		$('.detail-info table tr.less-info').show();
		$('#less-info').show();
		$('#more-info').hide();

		return false;
	});

	$('#less-info').click(function() {
		$('.detail-info table tr.less-info').hide();
		$('#less-info').hide();
		$('#more-info').show();

		return false;
	});
});

function topDetailNav() {
	var topNavsA = $('.top-navs a');
	var detailLeft = $('.detail-left');
	var detailControls = $('.detail-controls');
	var brokerInfo = $('#main-broker-info');
	topNavsA.click(function(e) {
		e.preventDefault();
		$(this).tab('show');
	});
	topNavsA.on('shown', function (e) {
		if (e.target.hash == '#hypoteka') {
			detailLeft.hide();
			detailControls.hide();
			brokerInfo.hide();
		} else {
			detailLeft.show();
			detailControls.show();
			brokerInfo.show();
		}
	});
}

$(document).ready(function(){
	if ($('#auction_box')) {
       	if (window.location.hash=='#auction_box') {
			$('#auction_box').show('slow');
			$('html, body').animate({
				scrollTop: $('#auction_box').offset().top
			}, 1000);
		}
        $('#auction_box_show').click(function(event){
            $('#auction_box').show('slow');
            event.stopPropagation();
            event.preventDefault();
            $('html, body').animate({
                scrollTop: $('#auction_box').offset().top
            }, 1000);
        });
        $('#auction_countdown').countdown($('#auction_until').val(),function(event) {
            if (event.elapsed) {
                $('#auction_box_show').hide();
                $('#auction_box').hide('slow');
                return;
            }

            var dateDiff = '';
            if (event.offset.totalDays==1) {
                dateDiff += '1 den ';
            }
            if (event.offset.totalDays>1 && event.offset.totalDays<5) {
                dateDiff = dateDiff + event.offset.totalDays + ' dny ';
            }
            if (event.offset.totalDays>4) {
                dateDiff = dateDiff + event.offset.totalDays + ' dnů ';
            }
            if (event.offset.hours==1) {
                dateDiff += '1 hodina ';
            }
            if (event.offset.hours>1) {
                dateDiff = dateDiff + event.offset.hours + ' hodin ';
            }

            dateDiff += event.offset.minutes + ' minut ';
            dateDiff += event.offset.seconds + ' vteřin ';

            $(this).html(dateDiff);
        });
    }
});

/* ------------------------------------------------------------------------
 Class: prettyPhoto
 Use: Lightbox clone for jQuery
 Author: Stephane Caron (http://www.no-margin-for-errors.com)
 Version: 3.1.5
 ------------------------------------------------------------------------- */
(function (e) {
	function t() {
		var e = location.href;
		hashtag = e.indexOf("#prettyPhoto") !== -1 ? decodeURI(e.substring(e.indexOf("#prettyPhoto") + 1, e.length)) : false;
		return hashtag
	}

	function n() {
		if (typeof theRel == "undefined")return;
		//location.hash = theRel + "/" + rel_index + "/"
	}

	function r() {
		//if (location.href.indexOf("#prettyPhoto") !== -1)location.hash = "prettyPhoto"
	}

	function i(e, t) {
		e = e.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var n = "[\\?&]" + e + "=([^&#]*)";
		var r = new RegExp(n);
		var i = r.exec(t);
		return i == null ? "" : i[1]
	}

	e.prettyPhoto = {version:"3.1.5"};
	e.fn.prettyPhoto = function (s) {
		function g() {
			e(".pp_loaderIcon").hide();
			projectedTop = scroll_pos["scrollTop"] + (d / 2 - a["containerHeight"] / 2);
			if (projectedTop < 0)projectedTop = 0;
			$ppt.fadeTo(settings.animation_speed, 1);
			$pp_pic_holder.find(".pp_content").animate({height:a["contentHeight"], width:a["contentWidth"]}, settings.animation_speed);
			$pp_pic_holder.animate({top:projectedTop, left:v / 2 - a["containerWidth"] / 2 < 0 ? 0 : v / 2 - a["containerWidth"] / 2, width:a["containerWidth"]}, settings.animation_speed, function () {
				$pp_pic_holder.find(".pp_hoverContainer,#fullResImage").height(a["height"]).width(a["width"]);
				$pp_pic_holder.find(".pp_fade").fadeIn(settings.animation_speed);
				if (isSet && S(pp_images[set_position]) == "image") {
					$pp_pic_holder.find(".pp_hoverContainer").show()
				} else {
					$pp_pic_holder.find(".pp_hoverContainer").hide()
				}
				if (settings.allow_expand) {
					if (a["resized"]) {
						e("a.pp_expand,a.pp_contract").show()
					} else {
						e("a.pp_expand").hide()
					}
				}
				if (settings.autoplay_slideshow && !m && !f)e.prettyPhoto.startSlideshow();
				settings.changepicturecallback();
				f = true
			});
			C();
			s.ajaxcallback()
		}

		function y(t) {
			$pp_pic_holder.find("#pp_full_res object,#pp_full_res embed").css("visibility", "hidden");
			$pp_pic_holder.find(".pp_fade").fadeOut(settings.animation_speed, function () {
				e(".pp_loaderIcon").show();
				t()
			})
		}

		function b(t) {
			t > 1 ? e(".pp_nav").show() : e(".pp_nav").hide()
		}

		function w(e, t) {
			resized = false;
			E(e, t);
			imageWidth = e, imageHeight = t;
			if ((p > v || h > d) && doresize && settings.allow_resize && !u) {
				resized = true, fitting = false;
				while (!fitting) {
					if (p > v) {
						imageWidth = v - 200;
						imageHeight = t / e * imageWidth
					} else if (h > d) {
						imageHeight = d - 200;
						imageWidth = e / t * imageHeight
					} else {
						fitting = true
					}
					h = imageHeight, p = imageWidth
				}
				if (p > v || h > d) {
					w(p, h)
				}
				E(imageWidth, imageHeight)
			}
			return{width:Math.floor(imageWidth), height:Math.floor(imageHeight), containerHeight:Math.floor(h), containerWidth:Math.floor(p) + settings.horizontal_padding * 2, contentHeight:Math.floor(l), contentWidth:Math.floor(c), resized:resized}
		}

		function E(t, n) {
			t = parseFloat(t);
			n = parseFloat(n);
			$pp_details = $pp_pic_holder.find(".pp_details");
			$pp_details.width(t);
			detailsHeight = parseFloat($pp_details.css("marginTop")) + parseFloat($pp_details.css("marginBottom"));
			$pp_details = $pp_details.clone().addClass(settings.theme).width(t).appendTo(e("body")).css({position:"absolute", top:-1e4});
			detailsHeight += $pp_details.height();
			detailsHeight = detailsHeight <= 34 ? 36 : detailsHeight;
			$pp_details.remove();
			$pp_title = $pp_pic_holder.find(".ppt");
			$pp_title.width(t);
			titleHeight = parseFloat($pp_title.css("marginTop")) + parseFloat($pp_title.css("marginBottom"));
			$pp_title = $pp_title.clone().appendTo(e("body")).css({position:"absolute", top:-1e4});
			titleHeight += $pp_title.height();
			$pp_title.remove();
			l = n + detailsHeight;
			c = t;
			h = l + titleHeight + $pp_pic_holder.find(".pp_top").height() + $pp_pic_holder.find(".pp_bottom").height();
			p = t
		}

		function S(e) {
			if (e.match(/youtube\.com\/watch/i) || e.match(/youtu\.be/i)) {
				return"youtube"
			} else if (e.match(/vimeo\.com/i)) {
				return"vimeo"
			} else if (e.match(/\b.mov\b/i)) {
				return"quicktime"
			} else if (e.match(/\b.swf\b/i)) {
				return"flash"
			} else if (e.match(/\biframe=true\b/i)) {
				return"iframe"
			} else if (e.match(/\bajax=true\b/i)) {
				return"ajax"
			} else if (e.match(/\bcustom=true\b/i)) {
				return"custom"
			} else if (e.substr(0, 1) == "#") {
				return"inline"
			} else {
				return"image"
			}
		}

		function x() {
			if (doresize && typeof $pp_pic_holder != "undefined") {
				scroll_pos = T();
				contentHeight = $pp_pic_holder.height(), contentwidth = $pp_pic_holder.width();
				projectedTop = d / 2 + scroll_pos["scrollTop"] - contentHeight / 2;
				if (projectedTop < 0)projectedTop = 0;
				if (contentHeight > d)return;
				$pp_pic_holder.css({top:projectedTop, left:v / 2 + scroll_pos["scrollLeft"] - contentwidth / 2})
			}
		}

		function T() {
			if (self.pageYOffset) {
				return{scrollTop:self.pageYOffset, scrollLeft:self.pageXOffset}
			} else if (document.documentElement && document.documentElement.scrollTop) {
				return{scrollTop:document.documentElement.scrollTop, scrollLeft:document.documentElement.scrollLeft}
			} else if (document.body) {
				return{scrollTop:document.body.scrollTop, scrollLeft:document.body.scrollLeft}
			}
		}

		function N() {
			d = e(window).height(), v = e(window).width();
			if (typeof $pp_overlay != "undefined")$pp_overlay.height(e(document).height()).width(v)
		}

		function C() {
			if (isSet && settings.overlay_gallery && S(pp_images[set_position]) == "image") {
				itemWidth = 52 + 5;
				navWidth = settings.theme == "facebook" || settings.theme == "pp_default" ? 50 : 30;
				itemsPerPage = Math.floor((a["containerWidth"] - 100 - navWidth) / itemWidth);
				itemsPerPage = itemsPerPage < pp_images.length ? itemsPerPage : pp_images.length;
				totalPage = Math.ceil(pp_images.length / itemsPerPage) - 1;
				if (totalPage == 0) {
					navWidth = 0;
					$pp_gallery.find(".pp_arrow_next,.pp_arrow_previous").hide()
				} else {
					$pp_gallery.find(".pp_arrow_next,.pp_arrow_previous").show()
				}
				galleryWidth = itemsPerPage * itemWidth;
				fullGalleryWidth = pp_images.length * itemWidth;
				$pp_gallery.css("margin-left", -(galleryWidth / 2 + navWidth / 2)).find("div:first").width(galleryWidth + 5).find("ul").width(fullGalleryWidth).find("li.selected").removeClass("selected");
				goToPage = Math.floor(set_position / itemsPerPage) < totalPage ? Math.floor(set_position / itemsPerPage) : totalPage;
				e.prettyPhoto.changeGalleryPage(goToPage);
				$pp_gallery_li.filter(":eq(" + set_position + ")").addClass("selected")
			} else {
				$pp_pic_holder.find(".pp_content").unbind("mouseenter mouseleave")
			}
		}

		function k(t) {
			if (settings.social_tools)facebook_like_link = settings.social_tools.replace("{location_href}", encodeURIComponent(location.href));
			settings.markup = settings.markup.replace("{pp_social}", "");
			e("body").append(settings.markup);
			$pp_pic_holder = e(".pp_pic_holder"), $ppt = e(".ppt"), $pp_overlay = e("div.pp_overlay");
			if (isSet && settings.overlay_gallery) {
				currentGalleryPage = 0;
				toInject = "";
				for (var n = 0; n < pp_images.length; n++) {
					if (!pp_images[n].match(/\b(jpg|jpeg|png|gif)\b/gi)) {
						classname = "default";
						img_src = ""
					} else {
						classname = "";
						img_src = pp_images[n]
					}
					toInject += "<li class='" + classname + "'><a href='#'><img src='" + img_src + "' width='50' alt='' /></a></li>"
				}
				toInject = settings.gallery_markup.replace(/{gallery}/g, toInject);
				$pp_pic_holder.find("#pp_full_res").after(toInject);
				$pp_gallery = e(".pp_pic_holder .pp_gallery"), $pp_gallery_li = $pp_gallery.find("li");
				$pp_gallery.find(".pp_arrow_next").click(function () {
					e.prettyPhoto.changeGalleryPage("next");
					e.prettyPhoto.stopSlideshow();
					return false
				});
				$pp_gallery.find(".pp_arrow_previous").click(function () {
					e.prettyPhoto.changeGalleryPage("previous");
					e.prettyPhoto.stopSlideshow();
					return false
				});
				$pp_pic_holder.find(".pp_content").hover(function () {
					$pp_pic_holder.find(".pp_gallery:not(.disabled)").fadeIn()
				}, function () {
					$pp_pic_holder.find(".pp_gallery:not(.disabled)").fadeOut()
				});
				itemWidth = 52 + 5;
				$pp_gallery_li.each(function (t) {
					e(this).find("a").click(function () {
						e.prettyPhoto.changePage(t);
						e.prettyPhoto.stopSlideshow();
						return false
					})
				})
			}
			if (settings.slideshow) {
				$pp_pic_holder.find(".pp_nav").prepend('<a href="#" class="pp_play">Play</a>');
				$pp_pic_holder.find(".pp_nav .pp_play").click(function () {
					e.prettyPhoto.startSlideshow();
					return false
				})
			}
			$pp_pic_holder.attr("class", "pp_pic_holder " + settings.theme);
			$pp_overlay.css({opacity:0, height:e(document).height(), width:e(window).width()}).bind("click", function () {
				if (!settings.modal)e.prettyPhoto.close()
			});
			e("a.pp_close").bind("click", function () {
				e.prettyPhoto.close();
				return false
			});
			if (settings.allow_expand) {
				e("a.pp_expand").bind("click", function (t) {
					if (e(this).hasClass("pp_expand")) {
						e(this).removeClass("pp_expand").addClass("pp_contract");
						doresize = false
					} else {
						e(this).removeClass("pp_contract").addClass("pp_expand");
						doresize = true
					}
					y(function () {
						e.prettyPhoto.open()
					});
					return false
				})
			}
			$pp_pic_holder.find(".pp_previous, .pp_nav .pp_arrow_previous").bind("click", function () {
				e.prettyPhoto.changePage("previous");
				e.prettyPhoto.stopSlideshow();
				return false
			});
			$pp_pic_holder.find(".pp_next, .pp_nav .pp_arrow_next").bind("click", function () {
				e.prettyPhoto.changePage("next");
				e.prettyPhoto.stopSlideshow();
				return false
			});
			x()
		}

		s = jQuery.extend({hook:"rel", animation_speed:"fast", ajaxcallback:function () {
		}, slideshow:5e3, autoplay_slideshow:false, opacity:.8, show_title:true, allow_resize:true, allow_expand:true, default_width:500, default_height:344, counter_separator_label:"/", theme:"pp_default", horizontal_padding:20, hideflash:false, wmode:"opaque", autoplay:true, modal:false, deeplinking:true, overlay_gallery:true, overlay_gallery_max:80, keyboard_shortcuts:true, changepicturecallback:function () {
		}, callback:function () {
		}, ie6_fallback:true, markup:'<div class="pp_pic_holder"> 						<div class="ppt"> </div> 						<div class="pp_top"> 							<div class="pp_left"></div> 							<div class="pp_middle"></div> 							<div class="pp_right"></div> 						</div> 						<div class="pp_content_container"> 							<div class="pp_left"> 							<div class="pp_right"> 								<div class="pp_content"> 									<div class="pp_loaderIcon"></div> 									<div class="pp_fade"> 										<a href="#" class="pp_expand" title="Expand the image">Expand</a> 										<div class="pp_hoverContainer"> 											<a class="pp_next" href="#">next</a> 											<a class="pp_previous" href="#">previous</a> 										</div> 										<div id="pp_full_res"></div> 										<div class="pp_details"> 											<div class="pp_nav"> 												<a href="#" class="pp_arrow_previous">Previous</a> 												<p class="currentTextHolder">0/0</p> 												<a href="#" class="pp_arrow_next">Next</a> 											</div> 											<p class="pp_description"></p> 											<div class="pp_social">{pp_social}</div> 											<a class="pp_close" href="#">Close</a> 										</div> 									</div> 								</div> 							</div> 							</div> 						</div> 						<div class="pp_bottom"> 							<div class="pp_left"></div> 							<div class="pp_middle"></div> 							<div class="pp_right"></div> 						</div> 					</div> 					<div class="pp_overlay"></div>', gallery_markup:'<div class="pp_gallery"> 								<a href="#" class="pp_arrow_previous">Previous</a> 								<div> 									<ul> 										{gallery} 									</ul> 								</div> 								<a href="#" class="pp_arrow_next">Next</a> 							</div>', image_markup:'<img id="fullResImage" src="{path}" />', flash_markup:'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="{width}" height="{height}"><param name="wmode" value="{wmode}" /><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="{path}" /><embed src="{path}" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="{width}" height="{height}" wmode="{wmode}"></embed></object>', quicktime_markup:'<object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" height="{height}" width="{width}"><param name="src" value="{path}"><param name="autoplay" value="{autoplay}"><param name="type" value="video/quicktime"><embed src="{path}" height="{height}" width="{width}" autoplay="{autoplay}" type="video/quicktime" pluginspage="http://www.apple.com/quicktime/download/"></embed></object>', iframe_markup:'<iframe src ="{path}" width="{width}" height="{height}" frameborder="no" allowfullscreen="allowfullscreen"></iframe>', inline_markup:'<div class="pp_inline">{content}</div>', custom_markup:""}, s);
		var o = this, u = false, a, f, l, c, h, p, d = e(window).height(), v = e(window).width(), m;
		doresize = true, scroll_pos = T();
		e(window).unbind("resize.prettyphoto").bind("resize.prettyphoto", function () {
			x();
			N()
		});
		if (s.keyboard_shortcuts) {
			e(document).unbind("keydown.prettyphoto").bind("keydown.prettyphoto", function (t) {
				if (typeof $pp_pic_holder != "undefined") {
					if ($pp_pic_holder.is(":visible")) {
						switch (t.keyCode) {
							case 37:
								e.prettyPhoto.changePage("previous");
								t.preventDefault();
								break;
							case 39:
								e.prettyPhoto.changePage("next");
								t.preventDefault();
								break;
							case 27:
								if (!settings.modal)e.prettyPhoto.close();
								t.preventDefault();
								break
						}
					}
				}
			})
		}
		e.prettyPhoto.initialize = function () {
			settings = s;
			if (settings.theme == "pp_default")settings.horizontal_padding = 16;
			theRel = e(this).attr(settings.hook);
			galleryRegExp = /\[(?:.*)\]/;
			isSet = galleryRegExp.exec(theRel) ? true : false;
			pp_images = isSet ? jQuery.map(o, function (t, n) {
				if (e(t).attr(settings.hook).indexOf(theRel) != -1)return e(t).attr("href")
			}) : e.makeArray(e(this).attr("href"));
			pp_titles = isSet ? jQuery.map(o, function (t, n) {
				if (e(t).attr(settings.hook).indexOf(theRel) != -1)return e(t).find("img").attr("alt") ? e(t).find("img").attr("alt") : ""
			}) : e.makeArray(e(this).find("img").attr("alt"));
			pp_descriptions = isSet ? jQuery.map(o, function (t, n) {
				if (e(t).attr(settings.hook).indexOf(theRel) != -1)return e(t).attr("title") ? e(t).attr("title") : ""
			}) : e.makeArray(e(this).attr("title"));
			if (pp_images.length > settings.overlay_gallery_max)settings.overlay_gallery = false;
			set_position = jQuery.inArray(e(this).attr("href"), pp_images);
			rel_index = isSet ? set_position : e("a[" + settings.hook + "^='" + theRel + "']").index(e(this));
			k(this);
			if (settings.allow_resize)e(window).bind("scroll.prettyphoto", function () {
				x()
			});
			e.prettyPhoto.open();
			return false
		};
		e.prettyPhoto.open = function (t) {
			if (typeof settings == "undefined") {
				settings = s;
				pp_images = e.makeArray(arguments[0]);
				pp_titles = arguments[1] ? e.makeArray(arguments[1]) : e.makeArray("");
				pp_descriptions = arguments[2] ? e.makeArray(arguments[2]) : e.makeArray("");
				isSet = pp_images.length > 1 ? true : false;
				set_position = arguments[3] ? arguments[3] : 0;
				k(t.target)
			}
			if (settings.hideflash)e("object,embed,iframe[src*=youtube],iframe[src*=vimeo]").css("visibility", "hidden");
			b(e(pp_images).size());
			e(".pp_loaderIcon").show();
			if (settings.deeplinking)n();
			if (settings.social_tools) {
				facebook_like_link = settings.social_tools.replace("{location_href}", encodeURIComponent(location.href));
				$pp_pic_holder.find(".pp_social").html(facebook_like_link)
			}
			if ($ppt.is(":hidden"))$ppt.css("opacity", 0).show();
			$pp_overlay.show().fadeTo(settings.animation_speed, settings.opacity);
			$pp_pic_holder.find(".currentTextHolder").text(set_position + 1 + settings.counter_separator_label + e(pp_images).size());
			if (typeof pp_descriptions[set_position] != "undefined" && pp_descriptions[set_position] != "") {
				$pp_pic_holder.find(".pp_description").show().html(unescape(pp_descriptions[set_position]))
			} else {
				$pp_pic_holder.find(".pp_description").hide()
			}
			movie_width = parseFloat(i("width", pp_images[set_position])) ? i("width", pp_images[set_position]) : settings.default_width.toString();
			movie_height = parseFloat(i("height", pp_images[set_position])) ? i("height", pp_images[set_position]) : settings.default_height.toString();
			u = false;
			if (movie_height.indexOf("%") != -1) {
				movie_height = parseFloat(e(window).height() * parseFloat(movie_height) / 100 - 150);
				u = true
			}
			if (movie_width.indexOf("%") != -1) {
				movie_width = parseFloat(e(window).width() * parseFloat(movie_width) / 100 - 150);
				u = true
			}
			$pp_pic_holder.fadeIn(function () {
				settings.show_title && pp_titles[set_position] != "" && typeof pp_titles[set_position] != "undefined" ? $ppt.html(unescape(pp_titles[set_position])) : $ppt.html(" ");
				imgPreloader = "";
				skipInjection = false;
				switch (S(pp_images[set_position])) {
					case"image":
						imgPreloader = new Image;
						nextImage = new Image;
						if (isSet && set_position < e(pp_images).size() - 1)nextImage.src = pp_images[set_position + 1];
						prevImage = new Image;
						if (isSet && pp_images[set_position - 1])prevImage.src = pp_images[set_position - 1];
						$pp_pic_holder.find("#pp_full_res")[0].innerHTML = settings.image_markup.replace(/{path}/g, pp_images[set_position]);
						imgPreloader.onload = function () {
							a = w(imgPreloader.width, imgPreloader.height);
							g()
						};
						imgPreloader.onerror = function () {
							alert("Image cannot be loaded. Make sure the path is correct and image exist.");
							e.prettyPhoto.close()
						};
						imgPreloader.src = pp_images[set_position];
						break;
					case"youtube":
						a = w(movie_width, movie_height);
						movie_id = i("v", pp_images[set_position]);
						if (movie_id == "") {
							movie_id = pp_images[set_position].split("youtu.be/");
							movie_id = movie_id[1];
							if (movie_id.indexOf("?") > 0)movie_id = movie_id.substr(0, movie_id.indexOf("?"));
							if (movie_id.indexOf("&") > 0)movie_id = movie_id.substr(0, movie_id.indexOf("&"))
						}
						movie = "https://www.youtube.com/embed/" + movie_id;
						i("rel", pp_images[set_position]) ? movie += "?rel=" + i("rel", pp_images[set_position]) : movie += "?rel=1";
						if (settings.autoplay)movie += "&autoplay=1";
						toInject = settings.iframe_markup.replace(/{width}/g, a["width"]).replace(/{height}/g, a["height"]).replace(/{wmode}/g, settings.wmode).replace(/{path}/g, movie);
						break;
					case"vimeo":
						a = ww(movie_width, movie_height);
						movie_id = pp_images[set_position];
						var t = /http(s?):\/\/(www\.)?vimeo.com\/(\d+)/;
						var n = movie_id.match(t);
						movie = "https://player.vimeo.com/video/" + n[3] + "?title=0&byline=0&portrait=0";
						if (settings.autoplay)movie += "&autoplay=1;";
						vimeo_width = a["width"] + "/embed/?moog_width=" + a["width"];
						toInject = settings.iframe_markup.replace(/{width}/g, vimeo_width).replace(/{height}/g, a["height"]).replace(/{path}/g, movie);
						break;
					case"quicktime":
						a = w(movie_width, movie_height);
						a["height"] += 15;
						a["contentHeight"] += 15;
						a["containerHeight"] += 15;
						toInject = settings.quicktime_markup.replace(/{width}/g, a["width"]).replace(/{height}/g, a["height"]).replace(/{wmode}/g, settings.wmode).replace(/{path}/g, pp_images[set_position]).replace(/{autoplay}/g, settings.autoplay);
						break;
					case"flash":
						a = w(movie_width, movie_height);
						flash_vars = pp_images[set_position];
						flash_vars = flash_vars.substring(pp_images[set_position].indexOf("flashvars") + 10, pp_images[set_position].length);
						filename = pp_images[set_position];
						filename = filename.substring(0, filename.indexOf("?"));
						toInject = settings.flash_markup.replace(/{width}/g, a["width"]).replace(/{height}/g, a["height"]).replace(/{wmode}/g, settings.wmode).replace(/{path}/g, filename + "?" + flash_vars);
						break;
					case"iframe":
						a = w(movie_width, movie_height);
						frame_url = pp_images[set_position];
						frame_url = frame_url.substr(0, frame_url.indexOf("iframe") - 1);
						toInject = settings.iframe_markup.replace(/{width}/g, a["width"]).replace(/{height}/g, a["height"]).replace(/{path}/g, frame_url);
						break;
					case"ajax":
						doresize = false;
						a = w(movie_width, movie_height);
						doresize = true;
						skipInjection = true;
						e.get(pp_images[set_position], function (e) {
							toInject = settings.inline_markup.replace(/{content}/g, e);
							$pp_pic_holder.find("#pp_full_res")[0].innerHTML = toInject;
							g()
						});
						break;
					case"custom":
						a = w(movie_width, movie_height);
						toInject = settings.custom_markup;
						break;
					case"inline":
						myClone = e(pp_images[set_position]).clone().append('<br clear="all" />').css({width:settings.default_width}).wrapInner('<div id="pp_full_res"><div class="pp_inline"></div></div>').appendTo(e("body")).show();
						doresize = false;
						a = w(e(myClone).width(), e(myClone).height());
						doresize = true;
						e(myClone).remove();
						toInject = settings.inline_markup.replace(/{content}/g, e(pp_images[set_position]).html());
						break
				}
				if (!imgPreloader && !skipInjection) {
					$pp_pic_holder.find("#pp_full_res")[0].innerHTML = toInject;
					g()
				}
			});
			return false
		};
		e.prettyPhoto.changePage = function (t) {
			currentGalleryPage = 0;
			if (t == "previous") {
				set_position--;
				if (set_position < 0)set_position = e(pp_images).size() - 1
			} else if (t == "next") {
				set_position++;
				if (set_position > e(pp_images).size() - 1)set_position = 0
			} else {
				set_position = t
			}
			rel_index = set_position;
			if (!doresize)doresize = true;
			if (settings.allow_expand) {
				e(".pp_contract").removeClass("pp_contract").addClass("pp_expand")
			}
			y(function () {
				e.prettyPhoto.open()
			})
		};
		e.prettyPhoto.changeGalleryPage = function (e) {
			if (e == "next") {
				currentGalleryPage++;
				if (currentGalleryPage > totalPage)currentGalleryPage = 0
			} else if (e == "previous") {
				currentGalleryPage--;
				if (currentGalleryPage < 0)currentGalleryPage = totalPage
			} else {
				currentGalleryPage = e
			}
			slide_speed = e == "next" || e == "previous" ? settings.animation_speed : 0;
			slide_to = currentGalleryPage * itemsPerPage * itemWidth;
			$pp_gallery.find("ul").animate({left:-slide_to}, slide_speed)
		};
		e.prettyPhoto.startSlideshow = function () {
			if (typeof m == "undefined") {
				$pp_pic_holder.find(".pp_play").unbind("click").removeClass("pp_play").addClass("pp_pause").click(function () {
					e.prettyPhoto.stopSlideshow();
					return false
				});
				m = setInterval(e.prettyPhoto.startSlideshow, settings.slideshow)
			} else {
				e.prettyPhoto.changePage("next")
			}
		};
		e.prettyPhoto.stopSlideshow = function () {
			$pp_pic_holder.find(".pp_pause").unbind("click").removeClass("pp_pause").addClass("pp_play").click(function () {
				e.prettyPhoto.startSlideshow();
				return false
			});
			clearInterval(m);
			m = undefined
		};
		e.prettyPhoto.close = function () {
			if ($pp_overlay.is(":animated"))return;
			e.prettyPhoto.stopSlideshow();
			$pp_pic_holder.stop().find("object,embed").css("visibility", "hidden");
			e("div.pp_pic_holder,div.ppt,.pp_fade").fadeOut(settings.animation_speed, function () {
				e(this).remove()
			});
			$pp_overlay.fadeOut(settings.animation_speed, function () {
				if (settings.hideflash)e("object,embed,iframe[src*=youtube],iframe[src*=vimeo]").css("visibility", "visible");
				e(this).remove();
				e(window).unbind("scroll.prettyphoto");
				r();
				settings.callback();
				doresize = true;
				f = false;
				delete settings
			})
		};
		if (!pp_alreadyInitialized && t()) {
			pp_alreadyInitialized = true;
			hashIndex = t();
			hashRel = hashIndex;
			hashIndex = hashIndex.substring(hashIndex.indexOf("/") + 1, hashIndex.length - 1);
			hashRel = hashRel.substring(0, hashRel.indexOf("/"));
			setTimeout(function () {
				e("a[" + s.hook + "^='" + hashRel + "']:eq(" + hashIndex + ")").trigger("click")
			}, 50)
		}
		return this.unbind("click.prettyphoto").bind("click.prettyphoto", e.prettyPhoto.initialize)
	};
})(jQuery);
var pp_alreadyInitialized = false;

var geocoder;
var map;
var infowindow = new google.maps.InfoWindow();
var bound = new google.maps.LatLngBounds();
var allMarkers = {1: [], 2: []};
var markers;
var markerCounter = 0;
var detailZoomVal = 15;
var iconPathTemplate;

function initialize(mapType) {
	geocoder = new google.maps.Geocoder();
	var myOptions = {
		zoom: 10,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	var mapElement;
	if (mapType == 1) {
		mapElement = document.getElementById("map_canvas");
	} else {
		mapElement = document.getElementById("map_canvas2");
	}

	map = new google.maps.Map(mapElement, myOptions);
	iconPathTemplate = $(mapElement).attr('data-marker-template');

	return map;

}

function codeAddress(map, mapType, address, zoomVal, infoBox, link, titulek, fotka) {
	var dOmarker = true;
	markers = allMarkers[mapType];
	var image;
	geocoder.geocode({'address': address}, function (results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			map.setZoom(zoomVal);
			var popupHtml = '<img src="' + fotka + '" align="left" style="width: 83px; margin: 3px 8px 0 0; border-radius: 2px"><strong style="color: #5488c7; font-family: Tahoma;">' + results[0].formatted_address + '</strong><br><strong style="font-weight: normal">' + titulek + '</strong><br>' + '<a href="' + link + '" style="color: #bc1c2c; font-weight: bold; text-decoration: underline">detail</a>';
			$.each(markers, function (index, el) {
				if (el.getPosition().equals(results[0].geometry.location)) {
					dOmarker = false;
					editInstructionText(index, popupHtml);
				}
			});
			if (dOmarker != false) {
				markerCounter++;
				var mapElements = $('#list-right-column #mapa');
				if (zoomVal == detailZoomVal && mapElements.length == 0) {
					image = iconPathTemplate.replace('#type#', '-main');
				} else if (mapElements.length != 0) {
					image = iconPathTemplate.replace('#type#', '-' + markerCounter);
				} else {
					image = iconPathTemplate.replace('#type#', '-' + markerCounter);
				}

				var marker = new google.maps.Marker({
					map: map,
					position: results[0].geometry.location,
					icon: image,
					html: popupHtml,
					adresa: results[0].formatted_address
				});
				markers.push(marker);
				attachInstructionText(marker);
				zoomToMarkers(map, markers);
			}
		}
	});
}

function attachInstructionText(marker) {
	google.maps.event.addListener(marker, 'click', function () {
		infowindow.setContent(
			marker.html
		);
		infowindow.open(map, marker);
	});
}

function editInstructionText(index, addHtml) {
	google.maps.event.addListener(markers[index], 'click', function () {
		infowindow.setContent(
			infowindow.getContent() + '<br><br>' + addHtml
		);
		infowindow.open(map, markers[index]);
	});
}

function changingMapPosition(mapType) {
	map = initialize(mapType);
	if (mapType == 1) {
		var i = 0;
		$('.estaddress_main').each(function (e) {
			i++;
			var adr = this;
			var adresa = adr.value.split('|');
			codeAddress(map, mapType, adresa[0], detailZoomVal, true, adresa[1], adresa[2], adresa[3]);
		});
	} else {
		markerCounter = 0;
		$('.estaddress').each(function (e) {
			var adr = this;
			var adresa = adr.value.split('|');
			codeAddress(map, mapType, adresa[0], 10, true, adresa[1], adresa[2], adresa[3]);
		});
	}
}

function zoomToMarkers(map, markers) {
	if (markers[0]) {
		var tempmark = markers[0].getPosition();
		var bounds = new google.maps.LatLngBounds(tempmark, tempmark);
		for (var i = 0; i < markers.length; i++) {
			bounds.extend(markers[i].getPosition());
		}
		map.fitBounds(bounds);
		if (!markers[1]) {
			map.setZoom(detailZoomVal);
		}
	}

}

$(function () {
	if ($('#detail').length != 0) {
		$('#gmap-tab').click(function () {
			if ($('#loaded1').val() != 'on') {
				changingMapPosition(1);
				$('#loaded1').val('on');
			}
		});
		$('#gmap-similar-tab').click(function () {
			if ($('#loaded2').val() != 'on') {
				changingMapPosition(2);
				$('#loaded2').val('on');
			}
		});
	}
	if ($('#list-right-column #mapa').length != 0) {
		$('#gmap-listing-list').click(function () {
			if ($('#loaded1').val() != 'on') {
				changingMapPosition(1);
				$('#loaded1').val('on');
			}
		});
	}
	if ($('#gmap-under-map').length != 0) {
		$('#show-gmap-under-map').click(function () {
			if ($('#loaded1').val() != 'on') {
				changingMapPosition(1);
				$('#loaded1').val('on');
			}
		});
	}
});

'Dalten.Form.Ajax'.namespace();

/**
 * Najde v contextu formy s id a atributem data-submitted-by=ajax a naváže na ně listener tak,
 * aby byly odesílány ajaxem.
 *
 * V (nepovinném) argumentu events se pod danými klíči očekávají funkce. Ty budou zavolány s následujícími parametry:
 * {Element} formulář, {Element} Data formuláře získaná z XHR, {String} Raw data z XHR.
 *
 * @param {Element} context Kde se mají hledat formy? (default: document)
 * @param {Object}  events  Pole event listenerů (klíče: afterFormReload, onSubmit).
 */
Dalten.Form.Ajax.start = function (context, events) {
	context = context || document;
	events = events || {};
	var handler = function (event) {
		var form = $(this), formId = form.attr('id');
		if ('onSubmit' in events) {
			events.onSubmit(form);
		}
		$.post(
			form.attr('action'),
			form.serializeArray(),
			function (data) {
				if (!data) {
					return;
				}
				var parsedData = $.parseHTML(data);
				form.replaceWith(parsedData);
				form = $('#' + formId);
				form.submit(handler);
				if ('afterFormReload' in events) {
					events.afterFormReload(form, parsedData, data);
				}
			}
		);
		event.preventDefault();
	};
	$('form[data-submitted-by=ajax][id]', context).submit(handler);
};
