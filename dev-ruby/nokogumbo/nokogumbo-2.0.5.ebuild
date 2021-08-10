# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="nokogumbo.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/nokogumbo/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/nokogumbo

inherit ruby-fakegem

DESCRIPTION="A Nokogiri interface to the Gumbo HTML5 parser"
HOMEPAGE="https://github.com/rubys/nokogumbo"
SRC_URI="https://github.com/rubys/nokogumbo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Contains a bundled and patched version of dev-libs/gumbo.

ruby_add_rdepend ">=dev-ruby/nokogiri-1.8.4"

all_ruby_prepare() {
	# Define rakehome in scope
	sed -i -e "1irakehome=File.expand_path('../../')" ext/nokogumbo/extconf.rb || die

	sed -i -e "s:require_relative ':require './:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Modern nokogiri doesn't have any ldflags part, rather than an empty one.
	sed -i -e '/have_libxml2/ s/empty/nil/' ext/nokogumbo/extconf.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
