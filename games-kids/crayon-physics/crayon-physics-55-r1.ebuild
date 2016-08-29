# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils gnome2-utils

DESCRIPTION="2D physics puzzle/sandbox game with drawing"
HOMEPAGE="http://www.crayonphysics.com/"
SRC_URI="crayon_physics_deluxe-linux-release${PV}.tar.gz"

LICENSE="CRAYON-PHYSICS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR="/opt/${PN}"
QA_PREBUILT="${MYGAMEDIR#/}/crayon
	${MYGAMEDIR#/}/lib32/*"

RDEPEND="
	dev-qt/qtcore:4[abi_x86_32(-)]
	dev-qt/qtgui:4[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x86? (
		!bundled-libs? (
			media-libs/libmikmod
			media-libs/libsdl:0[X,sound,video,opengl,joystick]
			media-libs/libvorbis
			media-libs/sdl-image[png,jpeg,tiff]
			media-libs/sdl-mixer[vorbis,wav]
			media-libs/smpeg[X,opengl]
			media-libs/tiff:0
			virtual/jpeg:0
		)
	)"

S=${WORKDIR}/CrayonPhysicsDeluxe

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_prepare() {
	if use bundled-libs ; then
		mv lib32/_libSDL-1.2.so.0 lib32/libSDL-1.2.so.0 || die
	fi
}

src_install() {
	insinto "${MYGAMEDIR}"
	use bundled-libs && doins -r lib32
	doins -r cache data crayon autoexec.txt version.xml

	newicon -s 256 icon.png ${PN}.png
	make_desktop_entry ${PN}
	make_wrapper ${PN} "./crayon" "${MYGAMEDIR}" "${MYGAMEDIR}/lib32"

	dodoc changelog.txt linux_hotfix_notes.txt
	dohtml readme.html

	fperms +x "${MYGAMEDIR}"/crayon
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
