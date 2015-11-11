# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem multilib

DESCRIPTION="Unicode Normalization Form support library for CRuby"
HOMEPAGE="http://sourceforge.jp/projects/unf/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/test-unit-2.5.1-r1
		dev-ruby/shoulda
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/ s:^:#:' Rakefile test/helper.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/unf_ext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/unf_ext CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" V=1
	cp ext/unf_ext/*$(get_modname) lib/ || die
}

each_ruby_test() {
	ruby-ng_testrb-2 test/test_*.rb
}
