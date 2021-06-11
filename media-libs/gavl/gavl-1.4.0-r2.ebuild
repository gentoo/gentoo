# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Library for handling uncompressed audio and video data"
HOMEPAGE="http://gmerlin.sourceforge.net"
SRC_URI="mirror://sourceforge/gmerlin/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ppc ~ppc64 x86"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}/${PV}-x32.diff" )

src_prepare() {
	default

	# AC_CONFIG_HEADERS, bug #467736
	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:-mfpmath=387::g' \
		-e 's:-O3 -funroll-all-loops -fomit-frame-pointer -ffast-math::g' \
		-e '/LDFLAGS=/d' \
		configure.ac || die

	export AT_M4DIR="m4"
	eautoreconf
}

multilib_src_configure() {
	# --disable-libpng because it's only used for tests
	local myeconfargs=(
		--without-doxygen # does nothing.
		--disable-libpng
		--disable-static
		--without-cpuflags
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake
	if multilib_is_native_abi && use doc; then
		doxygen doc/Doxyfile
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r apiref/.
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
