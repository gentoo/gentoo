# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-utils.eclass
# @MAINTAINER:
# Ruby team <ruby@gentoo.org>
# @AUTHOR:
# Author: Hans de Graaff <graaff@gentoo.org>
# @BLURB: An eclass for supporting ruby scripts and bindings in non-ruby packages
# @DESCRIPTION:
# The ruby-utils eclass is designed to allow an easier installation of
# Ruby scripts and bindings for non-ruby packages.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.


if [[ ! ${_RUBY_UTILS} ]]; then


# @ECLASS-VARIABLE: RUBY_TARGETS_PREFERENCE
# @INTERNAL
# @DESCRIPTION:
# This variable lists all the known ruby targets in preference of use as
# determined by the ruby team. By using this ordering rather than the
# USE_RUBY mandated ordering we have more control over which ruby
# implementation will be installed first (and thus eselected). This will
# provide for a better first installation experience.

# All RUBY_TARGETS
RUBY_TARGETS_PREFERENCE="ruby23 ruby22 "

# All other active ruby targets
RUBY_TARGETS_PREFERENCE+="ruby24 ruby25"


_ruby_implementation_depend() {
	local rubypn=
	local rubyslot=

	case $1 in
		ruby18)
			rubypn="dev-lang/ruby"
			rubyslot=":1.8"
			;;
		ruby19)
			rubypn="dev-lang/ruby"
			rubyslot=":1.9"
			;;
		ruby20)
			rubypn="dev-lang/ruby"
			rubyslot=":2.0"
			;;
		ruby21)
			rubypn="dev-lang/ruby"
			rubyslot=":2.1"
			;;
		ruby22)
			rubypn="dev-lang/ruby"
			rubyslot=":2.2"
			;;
		ruby23)
			rubypn="dev-lang/ruby"
			rubyslot=":2.3"
			;;
		ruby24)
			rubypn="dev-lang/ruby"
			rubyslot=":2.4"
			;;
		ruby25)
			rubypn="dev-lang/ruby"
			rubyslot=":2.5"
			;;
		ree18)
			rubypn="dev-lang/ruby-enterprise"
			rubyslot=":1.8"
			;;
		jruby)
			rubypn="dev-java/jruby"
			rubyslot=""
			;;
		rbx)
			rubypn="dev-lang/rubinius"
			rubyslot=""
			;;
		*) die "$1: unknown Ruby implementation"
	esac

	echo "$2${rubypn}$3${rubyslot}"
}



_RUBY_UTILS=1
fi
