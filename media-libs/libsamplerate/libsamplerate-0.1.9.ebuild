# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="Secret Rabbit Code (aka libsamplerate) is a Sample Rate Converter for audio"
HOMEPAGE="http://www.mega-nerd.com/SRC/"
SRC_URI="http://www.mega-nerd.com/SRC/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="sndfile static-libs"

RDEPEND="sndfile? ( >=media-libs/libsndfile-1.0.2 )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r6
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-0.1.3-dontbuild-tests-examples.patch"
		"${FILESDIR}/${PN}-0.1.8-lm.patch"
	)

	AT_M4DIR="M4" \
	autotools-multilib_src_prepare
}

src_configure() {
	my_configure() {
		local myeconfargs=(
			--disable-fftw
		)

		if [ "${ABI}" = "${DEFAULT_ABI}" ] ; then
			myeconfargs+=( $(use_enable sndfile) )
		else
			myeconfargs+=( --disable-sndfile )
		fi

		autotools-utils_src_configure

		if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
			sed -i -e "s/ doc examples//" "${BUILD_DIR}/Makefile" || die
		fi
	}
	multilib_parallel_foreach_abi my_configure
}

src_install() {
	autotools-multilib_src_install \
		htmldocdir="${EPREFIX}/usr/share/doc/${PF}/html"
}
