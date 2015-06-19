# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gaupol/gaupol-0.19.2-r1.ebuild,v 1.2 2015/06/11 15:07:39 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 fdo-mime gnome2-utils versionator

MAJOR_MINOR_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="Gaupol is a subtitle editor for text-based subtitles"
HOMEPAGE="http://home.gna.org/gaupol"
SRC_URI="http://download.gna.org/${PN}/${MAJOR_MINOR_VERSION}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="spell"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.16[${PYTHON_USEDEP}]
	spell? (
		app-text/iso-codes
		>=dev-python/pyenchant-1.4[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog CREDITS NEWS TODO README )

src_compile() {
	addpredict /root/.gconf
	addpredict /root/.gconfd
	distutils-r1_src_compile
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	elog "Previewing support needs MPlayer or VLC."

	if use spell; then
		elog "Additionally, spell-checking requires a dictionary, any of"
		elog "Aspell/Pspell, Ispell, MySpell, Uspell, Hspell or AppleSpell."
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
