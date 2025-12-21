# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="https://www.qsl.net/o/on4qz/"
SRC_URI="https://dev.gentoo.org/~tomjbe/distfiles/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-qt/qtbase:6[gui,network,ssl,widgets,xml]
	media-libs/hamlib:=
	media-libs/openjpeg:2
	media-libs/alsa-lib
	media-libs/libv4l
	sci-libs/fftw:3.0=
	|| (
		media-libs/libpulse
		media-sound/apulse[sdk]
	)"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils"

PATCHES=( "${FILESDIR}/${PN}-9.5.11-fix-broken-DRM-decode.patch"
	"${FILESDIR}/${PN}-9.5.11-drop-debug-output.patch" )

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" \
		qsstv.pro || die
}

src_configure() {
	filter-lto
	eqmake6 PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
