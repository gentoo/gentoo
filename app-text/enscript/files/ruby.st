/**
 * Name: ruby
 * Description: Ruby programming language.
 * Author: Mike Wilson <m.v.wilson@home.com>
 */

state ruby_comment
{
  /\*\\\// {
    language_print ($0);
    return;
  }
  LANGUAGE_SPECIALS {
   language_print ($0);
  }
}

state ruby_dquot_string
{
  /\\\\./ {
    language_print ($0);
  }
  /\"/ {
    language_print ($0);
    return;
  }
  LANGUAGE_SPECIALS {
    language_print ($0);
  }
}

state ruby_quot_string
{
  /\\\\./ {
    language_print ($0);
  }
  /[\']/ {
    language_print ($0);
    return;
  }
  LANGUAGE_SPECIALS {
    language_print ($0);
  }
}

state ruby_bquot_string
{
  /\\\\./ {
    language_print ($0);
  }
  /`/ {
    language_print ($0);
    return;
  }
  LANGUAGE_SPECIALS {
    language_print ($0);
  }
}

state ruby
{
  BEGIN {
    header ();
  }
  END {
    trailer ();
  }

  /* Comments. */
  /#[^{].*$/ {
    comment_face (true);
    language_print ($0);
    comment_face (false);
  }

  /* Ignore escaped quote marks */
  /\\\"/ {
    language_print ($0);
  }
  /\\\'/ {
    language_print ($0);
  }
  /\\\`/ {
    language_print ($0);
  }

  /* In cgi files, JavaScript might be imbedded, so we need to look out
   * for the JavaScript comments, because they might contain something
   * we don't like, like a contraction (don't, won't, etc.)
   * We won't put them in comment face, because they are not ruby
   * comments.
   */
  /\/\// {
    language_print ($0);
    call (eat_one_line);
  }

  /* String constants. */
  /\"/ {
    string_face (true);
    language_print ($0);
    call (ruby_dquot_string);
    string_face (false);
  }
  /[\']/ {
    string_face (true);
    language_print ($0);
    call (ruby_quot_string);
    string_face (false);
  }

  /* Backquoted command string */
  /`/ {
    string_face (true);
    language_print ($0);
    call (ruby_bquot_string);
    string_face (false);
  }

  /* Variables globals and instance */
  /[$@]\w+/ {
    variable_name_face (true);
    language_print ($0);
    variable_name_face (false);
  }

  /* Variables class variable */
  /@@\w+/ {
    variable_name_face (true);
    language_print ($0);
    variable_name_face (false);
  }

   /([ \t]*)(def)([ \t]+)([^(]*)/ {
    /* indentation */
    language_print ($1);

    /* def */
    keyword_face (true);
    language_print ($2);
    keyword_face (false);

    /* middle */
    language_print ($3);

    /* Function name. */
    function_name_face (true);
    language_print ($4);
    function_name_face (false);
  }

  /\$[!@&`'+~=\/\\,;.<>_*$?:"]/ {
    variable_name_face (true);
    language_print ($0);
    variable_name_face (false);
  }

  /* Highlighting
	--Type face
 	private protected public

	--Builtin face (I consider these to be somewhat special)
	alias alias_method attr attr_accessor attr_reader attr_writer 
	module_alias module_function self super

	--Reference face
	require include

	--Keyword face
	and begin break case class def defined? do else elsif end 
	ensure eval extend false for if in method module next nil not 
	or redo rescue retry return then true undef unless until when
	while yield
   */
/\\b(private|protected|public)\\b/ {
    type_face (true);
    language_print ($0);
    type_face (false);
  }

/\\b(alias|alias_method|attr|attr_accessor|attr_reader|attr_writer\\
|module_alias|module_function|self|super)\\b/ {
    builtin_face (true);
    language_print ($0);
    builtin_face (false);
  }

/\\b(include|require)\\b/ {
    reference_face (true);
    language_print ($0);
    reference_face (false);
  }

/\\b(and|begin|break|case|class|def|defined?|do|else|elsif|end|ensure|eval\\
|extend|false|for|if|in|method|module|next|nil|not|or|raise|redo|rescue|retry\\
|return|then|true|undef|unless|until|when|while|yield)\\b/ {
    keyword_face (true);
    language_print ($0);
    keyword_face (false);
  }

  LANGUAGE_SPECIALS {
    language_print ($0);
  }
}


/*
Local variables:
mode: c
End:
*/
