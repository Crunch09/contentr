//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.ui.nestedSortable

(function($) {
  
  $(function() {
    
    $('ol.sortable').nestedSortable({
			disableNesting: 'no-nest',
			forcePlaceholderSize: true,
			handle: 'div',
			helper:	'clone',
			items: 'li',
			//maxLevels: 3,
			opacity: .6,
			placeholder: 'placeholder',
			revert: 250,
			tabSize: 25,
			tolerance: 'pointer',
			toleranceElement: '> div'
		});
    
  });
  
})(jQuery);
