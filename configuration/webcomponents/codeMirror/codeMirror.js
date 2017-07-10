"use strict";

var cmInitialized = false;
var cmEditor = null;
var _focus = false;

function cm(gICAPI) {
	
	this.editor = CodeMirror.fromTextArea(document.getElementById("editor"), {
	  lineNumbers: true,
	  theme: "eclipse",
	  mode: "htmlmixed",
	  matchBrackets: true,
	  autoCloseBrackets: true,
	  autoCloseTags: true,
	  hint: {
        javascript: true,
	    xml: true,
	    html: true,
	    css:true
	  },
	  showCursorWhenSelecting: true,
	  extraKeys: {
	    "Cmd-S":function(cm) {
	    },
		"Ctrl-Space": "autocomplete"
	  }
	});
	const editor = this.editor;
	
	document.getElementById("select").addEventListener('change', function(e) {
		var mode = function() {
			switch(e.target.value) {
				case 'Javascript':
					return 'javascript';
				case 'CSS':
					return 'css';
				case 'HTML':
					return 'htmlmixed';
				case 'XML':
					return 'xml';
				case 'SASS':
					return 'sass';
				case '4GL':
					return '4gl'
			}
		};
		editor.setOption('mode', mode())
	});
	
	
	this.editor.on('blur', function(e) {
		_focus = false;
	});
	
	this.editor.on('focus', function(e) {
		gICAPI.SetFocus();
		_focus = true;
	});
	
	this.setContent = function(content){
		this.editor.setValue(content);
	}
	
	this.getContent = function(line_sep){
		return (this.editor.getValue(line_sep));
	}
	
	this.stateChanged = function(strParams) {
			var params = JSON.parse(strParams);
			var active = params.active === 1 ? true : params.active === "1" ? true : false;
			if (!active) {
			
			}
			else {
			
			}
	};
	
	this.setOption = function(option, value) {
		this.editor.setOption(option, value);
	}
	
	this.removeSelector = function() {
		const element = document.getElementById('languageSelector');
		element.parentNode.removeChild(element);
	}
	
	this.focus = function() {
		this.editor.focus();
	}
}

const initCm = function (gICAPI) {
	cmInitialized = true;
	return new cm(gICAPI);
}

var onICHostReady = function(version) {
	const whenReady = function(fn) {
		if (cmInitialized === false) {
			cmEditor = initCm(gICAPI);
			
		}
		fn(cmEditor);
	};
	
	if (version !== 1.0) {
		console.error('Invalid API version:',version);
	}
	
	gICAPI.onFocus = function (polarity) {
		whenReady(function (cmEditor) {
			if (polarity === true) {
				if (cmEditor !== null) {
					_focus = true;
					cmEditor.focus(); // will trigger editor focus event!
				}
			}
			else {
				_focus = false;
			}
		}.bind(this));
	};
	
	gICAPI.onData = function (data) {
		whenReady(function(cmEditor) {
			cmEditor.setContent(data);
		});
	};
	
	gICAPI.onProperty = function (p) {
		whenReady(function(cmEditor) {
			cmEditor.removeSelector();
			p = JSON.parse(p);
			if (p.language) {
				if (p.language === 'HTML') {
					cmEditor.setOption('mode', 'htmlmixed');
				}
				else if (p.language === 'CSS') {
					cmEditor.setOption('mode', 'css');
				}
			}
		})
	};
	
	gICAPI.onFlushData = function () {
		whenReady(function (cmEditor) {
			gICAPI.SetData(cmEditor.editor.getValue())
		}.bind(this));
	};
	
	gICAPI.onStateChanged = function(strParams) {
		whenReady(function (cmEditor) {
			cmEditor.stateChanged(strParams);
		})
	};
};