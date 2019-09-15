$(function(){
    var form = $('#frm-estateForm');
    $('input[name=next]').click(function() {
         var step = parseInt(form.find("input[name='step']").attr('value')) + 1;
         console.log(step);
         gotoStep(step);
     });

     $("input[name=back]").click(function() {
         console.log('Now step is ' + form.find('input[name=step]').attr('value'));
         var step = parseInt(form.find('input[name=step]').attr('value')) - 1;
         gotoStep(step);
     });

     function gotoStep(step) {
         console.log('And step is ' + step);
         var idEstate = form.find('input[name=id]').attr('value');
         form.find('input[name=step]').attr('value', step);
         var data = {};
         form.find(':input').each(function(index, ele) {
             if ($(this).val() !== "") {
                 data[ele.name] = $(this).val();
                 console.log('input is not empty');
             }
         });
         delete data['_do'];
         var url = form.attr('action');
         console.log(data);
         $.nette.ajax({
             type: 'POST',
             url: url,
             data: data
         });
     }
});
