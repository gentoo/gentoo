# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Text Progress Bar Library for Ruby"
HOMEPAGE="https://github.com/jfelchner/ruby-progressbar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rspectacular )"

all_ruby_prepare() {
	sed -i -e '/warning_filter/ s:^:#:' \
		spec/spec_helper.rb || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby20)
			# Skip specs since rspectacular doesn't work with ruby 2.0:
			# https://github.com/thekompanee/rspectacular/issues/4
			;;
		*)
			RSPEC_VERSION=3 ruby-ng_rspec spec || die
			;;
	esac
}
