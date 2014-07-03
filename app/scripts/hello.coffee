App = 
	currentSlide:-1
	lastTrigger:-1
	config:
		slides:[]
		triggerWait:15
	imagesLoaded:{}
	init:()->
		# App.addSlide 'images/slides/1.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/2.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/3.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/4.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/5.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/6.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/7.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/8.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/9.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		# App.addSlide 'images/slides/9.jpg', 'http://www.akufen.ca/app/assets/images/layout/ipad_logo-small.png'
		App.addSlide 'images/pabst.png', 'Si tu l\'ouvres t\'a fini', 9
		App.addSlide 'images/nain.png', 'Ne mets rien dans tes fesses', 132
		
		$(document).on 'mousemove', (e)->
			now = new Date().getTime();
			if now - App.config.triggerWait < App.lastTrigger
				return
			App.lastTrigger = now;

			x = e.pageX
			slideId = Math.floor(x/$(window).width()*App.config.slides.length)
			slideId = Math.floor(Math.random()*App.config.slides.length)
			App.setSlide(slideId);
		# $(window).on 'deviceorientation', (e)->
		# 	width = window.outerWidth
			

		# 	console.log 'e.gama', e

		$(window).on 'resize', (e)->
			jQuery('#background img').each (i,e)->
				App._coverImage this, 0

		$(window).trigger 'resize';
		$(document).trigger 'mousemove';

		$(document).on 'touchmove', (e)->
			$(document).trigger 'mousemove';
			return false;
		setInterval ()->
			jQuery(window).trigger 'resize'
		, 400;

	_coverImage:(img, jitter=0)->
		$img = jQuery(img);
		jitter = Math.floor(Math.random()*jitter)
		return
		if App.imagesLoaded[$img.attr('src')]?
			$fakeImg = App.imagesLoaded[$img.attr('src')];
			$fakeImg.trigger 'load';
		else
			$fakeImg = jQuery('<img />').data('realimage', $img).attr('src', $img.attr('src')).load ()->
				$this = jQuery(this);
				$img = jQuery($this.data('realimage'));

				$parent = $img.parent();
				minWidth = $parent.width();
				minHeight = $parent.height();

				newWidth = minWidth + jitter;
				newHeight = minWidth * (this.height/this.width);


				if newHeight < minHeight
					newHeight = minHeight + jitter;
					newWidth = minHeight * (this.width/this.height);


				marginTop = 0;
				marginLeft = 0;

				if $img.is('.bg-cover-center')
					marginTop = (minHeight - newHeight)/2;
					marginLeft = (minWidth - newWidth)/2;

				marginTop -= jitter/2
				marginLeft -= jitter/2

				$img.css('width', newWidth);
				$img.css('height', newHeight);
				$img.css('marginTop', marginTop);
				$img.css('marginLeft', marginLeft);
				App.imagesLoaded[$img.attr('src')] = $(this);


	setSlide:(id)->
		id = parseInt(id);
		if App.currentSlide == id || id < 0 || id >= App.config.slides.length
			return;
		App.currentSlide = id;
		slide = App.config.slides[id]
		$('#background .img').hide();
		slide.$img.show();

		$('#text').text(slide.text).hide()
		setTimeout ()->
			$('#text').fadeIn('slow');
		, 700
		clearTimeout App.logoTimer
		App.logoTimer = setTimeout ()->
			$('#logo').removeClass('animate')
		, 100
		$('#logo').addClass 'animate' 


	addSlide:(background,text,puke)->
		slide = {
			background:background,
			text:text
			puke:'Puke #'+puke
		}
		$img = $('<img />').attr('src', slide.background);
		$img = $('<div/>').attr('class', 'img').append($img).hide();
		$puke = $('<div />').attr('class', 'puke').text(slide.puke)
		$puke.appendTo $img
		slide.$img = $img;
		App.config.slides.push slide

		$('#background').append $img
		return slide;



$ (e)->
	App.init();

window.App = App;