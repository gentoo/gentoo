# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

PLOCALES="ca cs de el es fa fr gl he hr hu id it ja ko nl pl pt_BR ru sv uk zh_CN zh_TW"

inherit distutils-r1 fdo-mime l10n

DESCRIPTION="A fork of comix, a GTK image viewer for comic book archives"
HOMEPAGE="http://mcomix.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.14[${PYTHON_USEDEP}]
	virtual/jpeg
	dev-python/pillow[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf
	!media-gfx/comix"

DOCS=( ChangeLog README )

src_prepare() {
	local checklocales
	for l in $(find "${S}"/mcomix/messages/* -maxdepth 0 -type d);
		do checklocales+="$(basename $l) "
	done

	[[ ${PLOCALES} == ${checklocales% } ]] \
		|| eqawarn "Update to PLOCALES=\"${checklocales% }\""

	my_rm_loc() {
		rm -rf "${S}/mcomix/messages/${1}/LC_MESSAGES" || die
		rmdir "${S}/mcomix/messages/${1}" || die
	}

	l10n_for_each_disabled_locale_do my_rm_loc

	distutils-r1_src_prepare
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "    cbr: app-arch/unrar"
	elog "    cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha. Install app-text/mupdf for"
	elog "pdf support."
	echo
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
