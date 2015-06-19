# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/chemical-mime-data/chemical-mime-data-0.1.94-r2.ebuild,v 1.2 2014/08/10 20:28:26 slyfox Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fdo-mime

DESCRIPTION="A collection of data files to add support for chemical MIME types"
HOMEPAGE="http://chemical-mime.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/-data/}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	gnome-base/gnome-mime-data
	x11-misc/shared-mime-info"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/desktop-file-utils
	dev-libs/libxslt
	media-gfx/imagemagick[xml]
	media-gfx/inkscape
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-turbomole.patch
	"${FILESDIR}"/${P}-pigz.patch
	"${FILESDIR}"/${P}-namespace-svg.patch
	)

src_prepare() {
	# needed for convert/inkscape #464782
	export XDG_CONFIG_HOME=$HOME/.config
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-update-database
		--htmldir=/usr/share/doc/${PF}/html
		)
	autotools-utils_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	ewarn "You can ignore any 'Unknown media type in type' warnings."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	ewarn "You can ignore any 'Unknown media type in type' warnings."
}
