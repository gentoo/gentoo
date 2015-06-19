# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/kicad/kicad-20130518.ebuild,v 1.2 2014/08/10 20:27:55 slyfox Exp $

#TODO:
# - python and wxpython scripting

EAPI="5"

WX_GTK_VER="2.8"

inherit eutils unpacker cmake-utils wxwidgets fdo-mime gnome2-utils

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="http://www.kicad-pcb.org"

RELEASE_DATE="2013-05-18"
BZR_REV="4017"
UBUNTU_VER="12.04"
BASE_SRC_URI="http://iut-tice.ujf-grenoble.fr/cao"
SRC_URI="${BASE_SRC_URI}/${PN}-sources-stable_${RELEASE_DATE}_BZR${BZR_REV}.zip
	${BASE_SRC_URI}/${PN}-${RELEASE_DATE}-BZR${BZR_REV}-stable-UBUNTU_${UBUNTU_VER}_full_with_components_doc.tgz"

LICENSE="GPL-2 kicad-doc"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="debug"
LANGS="de en es fr hu it ja pl pt ru zh_CN"
for lang in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lang}"
done

CDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[gnome,opengl,X]
	dev-python/wxpython:${WX_GTK_VER}[opengl]"
DEPEND="${CDEPEND}
	>=dev-util/cmake-2.6.4
	>=dev-libs/boost-1.49[python]
	app-doc/doxygen"
RDEPEND="${CDEPEND}
	sys-libs/zlib
	sci-electronics/electronics-menu"

S="${WORKDIR}/stable_${RELEASE_DATE}_BZR${BZR_REV}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-native-boost.patch"
	epatch "${FILESDIR}/${PN}-desktop-file.patch"
	epatch "${FILESDIR}/${PN}-scripts.patch"
	epatch "${FILESDIR}/${PN}-missing-doc.patch"
	rm -f resources/linux/mime/applications/eeschema.desktop
}

src_configure() {
	need-wxwidgets unicode

	mycmakeargs="${mycmakeargs}
		-DKICAD_STABLE_VERSION=ON
		-DKICAD_wxUSE_UNICODE=ON
		-DKICAD_DOCS=/usr/share/doc/${PN}
		-DKICAD_HELP=/usr/share/doc/${PN}"

#		-DKICAD_SCRIPTING=ON
#		-DKICAD_SCRIPTING_MODULES=ON
#		-DKICAD_SCRIPTING_WXPYTHON=ON

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all doxygen-docs
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}/${PN}/share/library"
	doins -r "${WORKDIR}/${PN}/share/modules"

	insinto /usr/share/doc/${PN}
	doins -r "${WORKDIR}/${PN}/doc/contrib"

	insinto /usr/share/doc/${PN}/help
	for lang in $LANGS ; do
		if [[ -d "${WORKDIR}/${PN}/doc/help/${lang}" ]] ; then
			use linguas_$lang && doins -r "${WORKDIR}/${PN}/doc/help/${lang}"
		fi
	done

	insinto /usr/share/doc/${PN}/tutorials
	for lang in $LANGS ; do
		if [[ -d "${WORKDIR}/${PN}/doc/tutorials/${lang}" ]] ; then
			use linguas_$lang && doins -r "${WORKDIR}/${PN}/doc/tutorials/${lang}"
		fi
	done

	local dev_doc="/usr/share/doc/${PN}/development"
	insinto ${dev_doc}
	doins HOW_TO_CONTRIBUTE.txt notes_about_pcbnew_new_file_format.odt TODO.txt uncrustify.cfg
	doins "${WORKDIR}/${PN}/doc/help/file_formats/file_formats.pdf"
	cd Documentation
	doins -r *

	docompress -x \
		${dev_doc}/GUI_Translation_HOWTO.odt \
		${dev_doc}/notes_about_pcbnew_new_file_format.odt \
		${dev_doc}/uncrustify.cfg
		${dev_doc}/file_formats.pdf
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
