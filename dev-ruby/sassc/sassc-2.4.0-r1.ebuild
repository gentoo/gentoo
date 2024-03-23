# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Use libsass with Ruby"
HOMEPAGE="https://github.com/sass/sassc-ruby"
LICENSE="MIT"

KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
SLOT="2"
IUSE=""

RDEPEND+=">=dev-libs/libsass-3.6.1"

ruby_add_rdepend "
	>=dev-ruby/ffi-1.9.6
"

ruby_add_bdepend "test? (
	dev-ruby/test_construct
	dev-ruby/minitest-around
)"

all_ruby_prepare() {
	# Use unbundled libsass
	rm -rf ext || die

	sed -i -e "/ffi_lib/ s:__dir__:\"${ESYSROOT}/usr/$(get_libdir)\":" \
		lib/sassc/native.rb || die

	# Avoid version-specific test so newer libsass versions can be used.
	sed -i -e '/test_it_reports_the_libsass_version/,/end/ s:^:#:' test/native_test.rb || die

	# Fix minitest deprecation
	sed -i -e 's/MiniTest/Minitest/' test/*_test.rb || die

	sed -i -e '/pry/ s:^:#:' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_extensions_installed
}
