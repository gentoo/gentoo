# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="brotli.gemspec"

inherit ruby-fakegem

DESCRIPTION="Brotli compressor/decompressor"
HOMEPAGE="https://github.com/miyucy/brotli"
SRC_URI="https://github.com/miyucy/brotli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" >=app-arch/brotli-1.0.7"
DEPEND+=" >=app-arch/brotli-1.0.7"

# Depends on the test data in app-arch/brotli
RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext/brotli extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/brotli
	mv ext/brotli/brotli.so lib/brotli/ || die
}
