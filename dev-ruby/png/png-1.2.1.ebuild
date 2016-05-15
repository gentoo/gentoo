# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="An almost pure-Ruby Portable Network Graphics (PNG) library"
HOMEPAGE="http://docs.seattlerb.org/png/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
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

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r example
}
