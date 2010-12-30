(function($){  
$.fn.done = function(options) {  
function set_layouts(){
    $('body').layout({
        spacing_open: 0, 
        north__paneSelector: "#header",
        north__size: 25, 
        west__paneSelector: "#timeline",
        west__size: 200,
        center__paneSelector: '#content'
    });
    $('#content').layout({
        spacing_open: 0,
        center__paneSelector: '#things',
        east__paneSelector: '#grid',
        east__size: 260,
        south__paneSelector: '#input'
    });
}

$('#form-thing-post').submit(function(){
    var thing = this.thing;
    $.post(
        '/post',
        { content: thing.value },
        function(status){
            $('#things').load('/things');        
            thing.value = '';
        }
    );
    return false;
});    
    
// keybindings settings
var keybindings = {
    'i': function(){ $('#thing-what').select(); $('#form-thing-leading-colon').show();return false; }
};
// bind the keys
for ( var key in keybindings ){
    $(document).bind('keydown', { combi: key, disableInInput: true }, keybindings[key] );
}
$('#thing-what').bind('keydown', 'esc', function(){ 
    this.blur();
    $('#thing-what').val('');
});

function bind_class_at(c,h,m){
    $('#t-'+h+'-'+m).addClass(c);
}
function bind_class_during(c, sh,sm, dh,dm){
    if (sh == dh){
        for (var m=sm; m<dm; m++){
            $('#t-'+sh+'-'+m).addClass(c);
        }
    }else{
        for (var m=sm; m<60; m++){
            $('#t-'+sh+'-'+m).addClass(c);
        }
        for (var h=sh+1; h<dh; h++){
            for ( var m=0; m<60; m++ ){
                $('#t-'+h+'-'+m).addClass(c);
            }
        }
        for (var m=0; m<dm; m++){
            $('#t-'+dh+'-'+m).addClass(c);
        }
    }
}

// init status
$('#thing-what').val('');

$('#things').load('/things');        
return {  
    set_layouts: set_layouts,
    bind_class_during: bind_class_during,
    bind_class_at: bind_class_at
};  


};  
})(jQuery);

