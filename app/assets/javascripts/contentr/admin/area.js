jQuery(function($) {
  $(document).on('click', ".show_published_version", function(){
    var clicked = $(this);
    var link = clicked.data('href').replace(/PARAGRAPHID/, clicked.data('paragraph')).
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

  $('.contentr-sub-pages').sortable({
    items: 'li.sortable',
    handle: '.handle',
    update: function(event, ui) {
      var ids = $(this).sortable('serialize');
      var current_page = $(this).attr('data-page');
      var area_name = $(this).attr('data-area');
      $.ajax({
        type: "PATCH",
        url: $(this).data('reorder-path'),
        data: ids,
        error: function(msg) {
          alert("Error: Please try again.");
        }
      });
    }
  });

  $('.paragraph-add-btn').on('ajax:success', function(e, data, status, xhr){
    $('.existing-paragraphs[data-area="'+ $(this).data('area') +'"]').append(data);
    if($(data).find('.wysihtml').length > 0){
      $('.existing-paragraphs .wysihtml').wysihtml5({medium: true})
    }
  });

  $('.paragraph-edit-btn').on('ajax:success', function(e, data, status, xhr){
    var $paragraph = $('#paragraph_'+ $(this).data('id'));
    $paragraph.hide();
    $paragraph.after(data);
    if($(data).find('.wysihtml').length > 0){
      $('.existing-paragraphs .wysihtml').wysihtml5({medium: true})
    }
  });

  $(document).on('click', '.cancel-paragraph-edit-btn', function(){
    if($(this).data('id') !== null){
      var $paragraph = $('#paragraph_'+ $(this).data('id'));
      $paragraph.show();
    }
    $(this).closest('form').remove();
    return false;
  });

  $(document).on('ajax:success', 'form.paragraph', function(e, data, status, xhr){
    var paragraphId = $(this).data('id');
    if(paragraphId !== null){
      var $existingParagraph = $('#paragraph_'+ paragraphId);
      if($existingParagraph.length == 1){
        $existingParagraph.replaceWith(data);
      }
    }else{
      $('.existing-paragraphs[data-area="'+ $(this).closest('[data-area]').data('area') +'"]').append(data);
    }
    $(this).remove();
    return false;
  });

  $(document).on('change', '.new-paragraph-buttons #contentblock', function(){
    if($(this).val() === undefined){ return; }
    var $area = $(this).closest('.contentr-area');
    $.ajax({
      type: 'POST',
      url: $(this).data('href'),
      data: {
        content_block_usage: {
          content_block_id: $(this).val(),
          page_id: $area.data('page'),
          area_name: $area.data('area')
        }
      },
      success: function(data){
        $('.existing-paragraphs[data-area="area-'+ $area.data('area') +'"]').append(data);
      }
    });
    return false;
  });
});
