# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This gem bundles dejavu fonts, freefonts

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG"
RUBY_FAKEGEM_GEMSPEC="rbpdf-font.gemspec"

inherit ruby-fakegem toolchain-funcs

DESCRIPTION="Font files for the Ruby on Rails RBPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"
SRC_URI="https://github.com/naitoh/rbpdf/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="rbpdf-${PV}/rbpdf-font"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/test-unit-3:2"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile || die
	sed -i -e '2igem "test-unit", "~>3.0"' test/test_helper.rb || die

	pushd lib/fonts/src || die
	tar xf ttf2ufm-src.tar.gz || die
	emake -C ttf2ufm-src clean
	sed -i -e '/^CFLAGS_SYS=/ s/-O/$(CFLAGS)/' -e '/CFLAGS.*LIBS/ s/CFLAGS/LDFLAGS/' ttf2ufm-src/Makefile || die
	popd || die
}

each_ruby_prepare() {
	rm -rf lib/fonts/src || die
}

all_ruby_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" -C lib/fonts/src/ttf2ufm-src
}

each_ruby_install() {
	cp "${WORKDIR}/all/${RUBY_S}/lib/fonts/src/ttf2ufm-src/ttf2pt1" lib/fonts/ttf2ufm/ttf2ufm || die

	each_fakegem_install
}
