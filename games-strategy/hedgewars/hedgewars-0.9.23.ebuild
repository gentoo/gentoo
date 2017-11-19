# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils eutils xdg-utils

MY_P=${PN}-src-${PV}
DEB_PATCH_VER=7

DESCRIPTION="A turn-based strategy, artillery, action and comedy game"
HOMEPAGE="https://www.hedgewars.org/"
SRC_URI="https://www.hedgewars.org/download/releases/${MY_P}.tar.bz2
	mirror://debian/pool/main/h/${PN}/${PN}_0.9.22-dfsg-${DEB_PATCH_VER}.debian.tar.xz"

LICENSE="GPL-2 Apache-2.0 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav"

QA_FLAGS_IGNORED="/usr/bin/hwengine" # pascal sucks
QA_PRESTRIPPED="/usr/bin/hwengine" # pascal sucks

CDEPEND="
	>=dev-games/physfs-3.0.1
	dev-lang/lua:0=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/libpng:0=
	media-libs/libsdl2:=
	media-libs/sdl2-image:=
	media-libs/sdl2-mixer:=
	media-libs/sdl2-net:=
	media-libs/sdl2-ttf:=
	sys-libs/zlib:=
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:= )"
DEPEND="${CDEPEND}
	>=dev-lang/fpc-2.4"
RDEPEND="${CDEPEND}
	app-arch/xz-utils
	media-fonts/wqy-zenhei
	>=media-fonts/dejavu-2.28"

S=${WORKDIR}/${MY_P}
PATCHES=( "${FILESDIR}"/${PN}-0.9.22-rpath-fix.patch )

src_configure() {
	local mycmakeargs=(
		-DMINIMAL_FLAGS=ON
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share/${PN}"
		-Dtarget_binary_install_dir="${EPREFIX}/usr/bin"
		-Dtarget_library_install_dir="${EPREFIX}/usr/$(get_libdir)"
		-DNOSERVER=TRUE
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DPHYSFS_SYSTEM=ON
		# upstream sets RPATH that leafs to weird breakage
		# https://bugzilla.redhat.com/show_bug.cgi?id=1200193
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -f "${ED%/}"/usr/share/games/hedgewars/Data/Fonts/{DejaVuSans-Bold.ttf,wqy-zenhei.ttc} || die
	dosym ../../../fonts/dejavu/DejaVuSans-Bold.ttf \
		/usr/share/${PN}/Data/Fonts/DejaVuSans-Bold.ttf
	dosym ../../../fonts/wqy-zenhei/wqy-zenhei.ttc \
		/usr/share/${PN}/Data/Fonts/wqy-zenhei.ttc
	doicon misc/hedgewars.png
	make_desktop_entry ${PN} Hedgewars
	doman man/${PN}.6
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
