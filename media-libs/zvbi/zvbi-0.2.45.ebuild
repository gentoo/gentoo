# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal verify-sig

DESCRIPTION="VBI Decoding Library for Zapping"
HOMEPAGE="https://github.com/zapping-vbi/zvbi/"
SRC_URI="
	https://github.com/zapping-vbi/zvbi/archive/v${PV}.tar.gz -> ${P}.tar.gz
	verify-sig? ( https://github.com/zapping-vbi/zvbi/releases/download/v${PV}/v${PV}.tar.gz.asc -> ${P}.tar.gz.asc )
"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc dvb nls proxy test v4l X"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers
	X? ( x11-libs/libXt )
"
BDEPEND="
	doc? ( app-text/doxygen )
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-zvbi )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.45-fix_test_musl.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable dvb)
		$(use_enable nls)
		$(use_enable proxy)
		$(use_enable test tests)
		$(use_enable v4l)
		$(use_with X x)
		$(multilib_native_use_with doc doxygen)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		if use doc; then
			local HTML_DOCS=( doc/html/. )
			einstalldocs
		fi
	fi
}

multilib_src_install_all() {
	# examples are not built but used as doc
	local DOCS=( AUTHORS BUGS ChangeLog NEWS README.md TODO examples )
	docompress -x /usr/share/doc/${PF}/examples
	einstalldocs

	find "${ED}" -name '*.la' -delete
}
