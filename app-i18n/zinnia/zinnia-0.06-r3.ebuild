# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools flag-o-matic perl-module toolchain-funcs

DESCRIPTION="Zinnia - Online hand recognition system with machine learning"
HOMEPAGE="https://taku910.github.io/zinnia/ https://github.com/taku910/zinnia https://sourceforge.net/projects/zinnia/"
SRC_URI="mirror://sourceforge/zinnia/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="perl static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-c++11.patch
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-perl.patch
)

HTML_DOCS=( doc/{index{,-ja}.html,${PN}.css} )

src_prepare() {
	default
	sed -i "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" configure.in || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default

	if use perl; then
			cd perl >/dev/null || die
			# We need to run this here as otherwise it won't pick up the
			# just-built -lzinnia and cause the extension to have
			# undefined symbols.
			perl-module_src_configure

			append-cppflags "-I${S}"
			append-ldflags "-L${S}/.libs"

			emake \
				CC="$(tc-getCXX)" \
				LD="$(tc-getCXX)" \
				OPTIMIZE="${CPPFLAGS} ${CXXFLAGS}" \
				LDDLFLAGS="-shared" \
				OTHERLDFLAGS="${LDFLAGS}"
			cd - >/dev/null || die
	fi
}

src_test() {
	default
}

src_install() {
	default
	einstalldocs
	find "${D}" -name "*.la" -delete || die

	if use perl; then
			cd perl >/dev/null || die
			perl-module_src_install
			cd - >/dev/null || die
	fi
}
