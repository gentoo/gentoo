# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/ruby-single.eclass,v 1.2 2015/05/31 06:14:54 graaff Exp $

# @ECLASS: ruby-single
# @MAINTAINER:
# Ruby team <ruby@gentoo.org>
# @AUTHOR:
# Author: Hans de Graaff <graaff@gentoo.org>
# Based on python-single-r1 by: Michał Górny <mgorny@gentoo.org>
# @BLURB: An eclass for Ruby packages not installed for multiple implementations.
# @DESCRIPTION:
# An eclass for packages which don't support being installed for
# multiple Ruby implementations. This mostly includes ruby-based
# scripts.

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4|5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_RUBY_SINGLE} ]]; then

inherit ruby-utils

# @ECLASS-VARIABLE: USE_RUBY
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# This variable contains a space separated list of targets (see above) a package
# is compatible to. It must be set before the `inherit' call. There is no
# default. All ebuilds are expected to set this variable.


# @ECLASS-VARIABLE: RUBY_DEPS
# @DESCRIPTION:
#
# This is an eclass-generated Ruby dependency string for all
# implementations listed in USE_RUBY. Any one of the supported ruby
# targets will satisfy this dependency. A dependency on
# virtual/rubygems is also added to ensure that this is installed
# in time for the package to use it.
#
# Example use:
# @CODE
# RDEPEND="${RUBY_DEPS}
#   dev-foo/mydep"
# BDEPEND="${RDEPEND}"
# @
#
# Example value:
# @CODE
# || ( dev-lang/ruby:2.0 dev-lang/ruby:1.9 ) virtual/rubygems
# @CODE

_ruby_single_implementations_depend() {
	local depend
	for _ruby_implementation in ${RUBY_TARGETS_PREFERENCE}; do
		if [[ ${USE_RUBY} =~ ${_ruby_implementation} ]]; then
			depend="${depend} $(_ruby_implementation_depend $_ruby_implementation)"
		fi
	done
	echo "|| ( ${depend} ) virtual/rubygems"
}

_ruby_single_set_globals() {
	RUBY_DEPS=$(_ruby_single_implementations_depend)
}
_ruby_single_set_globals


_RUBY_SINGLE=1
fi
