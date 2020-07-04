<?php
/* Autoloader for dev-php/PHP_TokenStream */

if (!class_exists('Fedora\\Autoloader\\Autoload', false)) {
    require_once '/usr/share/php/Fedora/Autoloader/autoload.php';
}

\Fedora\Autoloader\Autoload::addClassMap(
   [
		'php_token' => '/Token.php',
		'php_tokenwithscope' => '/Token.php',
		'php_tokenwithscopeandvisibility' => '/Token.php',
		'php_token_open_tag' => '/Token.php',
		'php_token_util' => '/Token/Util.php',
		'php_token_stream' => '/Token/Stream.php',
		'php_token_stream_cachingfactory' => '/Token/Stream/CachingFactory.php',
    ],
    __DIR__
);
$_gentooFedAutoload = function() {
$_fedAutoLoadtokens = [];
$_fedAutoLoadtokenSubClasses = ['includes','function','interface','abstract','ampersand','and_equal',
'array','array_cast','as','at','backtick','bad_character','boolean_and','boolean_or','boolean_cast',
'break','caret','case','catch','character','class','class_c','class_name_constant','clone','close_bracket',
'close_curly','close_square','close_tag','colon','comma','comment','concat_equal','const','constant_encapsed_string',
'continue','curly_open','dec','declare','default','div','div_equal','dnumber','do','doc_comment','dollar',
'dollar_open_curly_braces','dot','double_arrow','double_cast','double_colon','double_quotes','echo','else',
'elseif','empty','encapsed_and_whitespace','enddeclare','endfor','endforeach','endif','endswitch','endwhile',
'end_heredoc','equal','eval','exclamation_mark','exit','extends','file','final','for','foreach','func_c','global',
'gt','if','implements','inc','include','include_once','inline_html','instanceof','int_cast','isset','is_equal',
'is_greater_or_equal','is_identical','is_not_equal','is_not_identical','is_smaller_or_equal','line','list',
'lnumber','logical_and','logical_or','logical_xor','lt','method_c','minus','minus_equal','mod_equal','mult',
'mult_equal','new','num_string','object_cast','object_operator','open_bracket','open_curly','open_square',
'open_tag','open_tag_with_echo','or_equal','paamayim_nekudotayim','percent','pipe','plus','plus_equal','print',
'private','protected','public','question_mark','require','require_once','return','semicolon','sl','sl_equal',
'sr','sr_equal','start_heredoc','static','string','string_cast','string_varname','switch','throw','tilde',
'try','unset','unset_cast','use','use_function','var','variable','while','whitespace','xor_equal','halt_compiler',
'dir','goto','namespace','ns_c','ns_separator','callable','insteadof','trait','trait_c','finally','yield',
'ellipsis','pow','pow_equal','coalesce','spaceship','yield_from','coalesce_equal','fn'
];
foreach($_fedAutoLoadtokenSubClasses as $_fedAutoLoadi)
	$_fedAutoLoadtokens["php_token_{$_fedAutoLoadi}"] = '/Token.php';
\Fedora\Autoloader\Autoload::addClassMap($_fedAutoLoadtokens, __DIR__);
};
$_gentooFedAutoload();
unset ($_gentooFedAutoload);

