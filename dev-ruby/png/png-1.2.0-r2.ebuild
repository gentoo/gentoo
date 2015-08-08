# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="An almost pure-Ruby Portable Network Graphics (PNG) library"
HOMEPAGE="http://rubyforge.org/projects/seattlerb/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/hoe )
	test? (
		dev-ruby/hoe
		dev-ruby/minitest
	)"

ruby_add_rdepend ">=dev-ruby/RubyInline-3.5.0"

all_ruby_prepare() {
	sed -i -e "/rubyforge/s/^/#/" Rakefile || die
	sed -i -e "1i# encoding: ascii-8bit" test/test_png.rb || die
}

src_test() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home."
	ruby-ng_src_test
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r example
}
