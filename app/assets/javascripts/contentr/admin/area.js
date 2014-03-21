jQuery(function($) {
  $(document).on('click', ".show_published_version", function(){
    var clicked = $(this);
    var link = clicked.data('href').replace(/PAGEID/, clicked.data('page')).replace(/PARAGRAPHID/, clicked.data('paragraph')).
      replace(/CURRENT/, clicked.data('current'));
    $.ajax({
      type: "GET",
      url: link,
      success: function(msg){
        $('#paragraph_'+ clicked.data('paragraph')+' .actual_content').html(msg);
        if(clicked.data("current") == "0"){
          clicked.text("Show unpublished version");
          clicked.data("current", "1");
          $("#publish-btn-"+ clicked.data('paragraph')).hide();
          $("#revert-btn-"+ clicked.data('paragraph')).show();
        }else{
          clicked.text("Show published version");
          $("#publish-btn-"+ clicked.data('paragraph')).show();
          $("#revert-btn-"+ clicked.data('paragraph')).hide();
          clicked.data("current", "0");
        }

      },
      error: function(msg){
        console.log("Error: "+ msg);
      }
    });
  });

  $('.contentr-area').sortable({
    items: '.existing-paragraphs > div.paragraph',
    handle: '.toolbar .handle',
    update: function(event, ui) {
      var ids = $(this).sortable('serialize');
      var current_page = $(this).attr('data-page');
      var area_name = $(this).attr('data-area');
      $.ajax({
        type: "PATCH",
        url: $(this).data('reorder-path').replace(/PAGE/, current_page).replace(/AREA/, area_name),
        data: ids,
        error: function(msg) {
          alert("Error: Please try again.");
        }
      });
    }
  });
});
