/**
 * Created by maxime on 15/06/17.
 */

const tmp = [
	{
		options: [ 'foo' ],
		'foo'  : {options: [ 'bar' ]}
	},
	{
		options: [ 'foo2' ],
		'foo2' : {options: [ 'bar2' ]}
	},
	{
		options: [ 'foo' ],
		'foo'  : {options: [ 'bar2' ]}
	},
	{
		options: [ 'foo3' ],
		'foo3' : {options: [ 'bar' ]}
	},
];

const reduced = tmp.reduce(function (accumulateur, currentElement, index, tmp) {
	return accumulateur
}, tmp[ 0 ]);

/*
 Expected value
 */
const tmpReduced = {
	options: [ 'foo', 'foo2', 'foo3' ],
	'foo'  : {options: [ 'bar', 'bar2' ]},
	'foo2' : {options: [ 'bar2' ]},
	'foo3' : {options: [ 'bar' ]}
};
