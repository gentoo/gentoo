# Copyright 2010-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools flag-o-matic perl-module toolchain-funcs

DESCRIPTION="Zinnia - Online hand recognition system with machine learning"
HOMEPAGE="https://taku910.github.io/zinnia/ https://github.com/taku910/zinnia https://sourceforge.net/projects/zinnia/"
SRC_URI="mirror://sourceforge/zinnia/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="perl static-libs"

PATCHES=(
	"${FILESDIR}/${P}-flags.patch"
	"${FILESDIR}/${P}-perl_build.patch"
	"${FILESDIR}/${P}-c++-2011.patch"
)

DOCS=(AUTHORS)

src_prepare() {
	default
	mv configure.in configure.ac || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf

	if use perl; then
			pushd perl > /dev/null
			PATCHES=()
			perl-module_src_prepare
			popd > /dev/null
	fi
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default

	if use perl; then
			pushd perl > /dev/null

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
			popd > /dev/null
	fi
}

src_test() {
	default
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die

	if use perl; then
			pushd perl > /dev/null
			perl-module_src_install
			popd > /dev/null
	fi

	(
		docinto html
		dodoc doc/*.css doc/*.html
	)
}
