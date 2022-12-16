# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="brotli.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/brotli/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Brotli compressor/decompressor"
HOMEPAGE="https://github.com/miyucy/brotli"
SRC_URI="https://github.com/miyucy/brotli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64"
IUSE=""

RDEPEND+=" >=app-arch/brotli-1.0.7"
DEPEND+=" >=app-arch/brotli-1.0.7"

# Depends on the test data in app-arch/brotli
RESTRICT="test"

all_ruby_prepare() {
	sed -e 's/git ls-files -z -- spec/find spec -print0/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
