# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="nokogumbo.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Nokogiri interface to the Gumbo HTML5 parser"
HOMEPAGE="https://github.com/rubys/nokogumbo"
SRC_URI="https://github.com/rubys/nokogumbo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Contains a bundled and patched version of dev-libs/gumbo.

ruby_add_rdepend ">=dev-ruby/nokogiri-1.8.4"

all_ruby_prepare() {
	# Define rakehome in scope
	sed -i -e "1irakehome=File.expand_path('../../')" ext/nokogumbo/extconf.rb || die

	sed -i -e "s:require_relative ':require './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	${RUBY} -Cext/nokogumbo extconf.rb || die
	sed -i -e 's:-Wl,--no-undefined::' ext/nokogumbo/Makefile || die
}

each_ruby_compile() {
	emake -Cext/nokogumbo V=1
	cp ext/nokogumbo/nokogumbo.so lib/nokogumbo/ || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
