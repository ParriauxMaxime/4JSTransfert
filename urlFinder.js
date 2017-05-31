/**
 * Created by maxime on 31/05/17.
 */

"use strict";

var urlInitialized = false;
var url = null;

function urlFinder(gICAPI) {
	const url = document.referrer;
	setTimeout(function() {
		console.log('here');
		gICAPI.SetData(url);
		gICAPI.SetFocus();
	}, 0)
}

const initURL = function (gICAPI) {
	urlInitialized = true;
	return new urlFinder(gICAPI);
}

var onICHostReady = function(version) {
	const whenReady = function(fn) {
		if (urlInitialized === false) {
			url = initURL(gICAPI);
		}
		fn(url);
	};
	
	if (version !== 1.0) {
		console.error('Invalid API version:',version);
	}
	
	gICAPI.onFocus = function (polarity) {
		console.log('onFocus', polarity);
		whenReady(function (url) {
		}.bind(this));
	};
	
	gICAPI.onData = function (data) {
		console.log('onData', data)
		whenReady(function(url) {
		});
	};
	
	gICAPI.onProperty = function (p) {
		whenReady(function(url) {
		})
	};
	
	gICAPI.onFlushData = function () {
		console.log('FlushData')
		whenReady(function (url) {
		}.bind(this));
	};
	
	gICAPI.onStateChanged = function(strParams) {
		whenReady(function (url) {
		})
	};
};

