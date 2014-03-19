//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap-wysihtml5
//= require contentr/overlay

(function($) {

  $(function() {
    // setup overlay for contentr admin
    $('a[rel=contentr-overlay]').contentr_overlay({
      width: '90%',
			height: '90%',
			close: function() {
			  location.reload();
			}
    });

    // make paragraphs sortable
  });

})(jQuery);
