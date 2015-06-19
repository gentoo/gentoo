# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/nimbus/nimbus-0.1.7-r1.ebuild,v 1.2 2015/05/29 09:02:17 haubi Exp $

EAPI=4
AUTOTOOLS_AUTO_DEPEND=no
inherit autotools gnome2-utils

DESCRIPTION="The default OpenSolaris theme (GTK+ 2.x engine, icon- and metacity theme)"
HOMEPAGE="http://dlc.sun.com/osol/jds/downloads/extras/nimbus/"
SRC_URI="http://dlc.sun.com/osol/jds/downloads/extras/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="gtk minimal"

COMMON_DEPEND="gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${COMMON_DEPEND}
	!minimal? ( || ( x11-themes/gnome-icon-theme x11-themes/tango-icon-theme ) )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=x11-misc/icon-naming-utils-0.8.90
	!gtk? ( ${AUTOTOOLS_DEPEND} )
	elibc_Interix? ( ${AUTOTOOLS_DEPEND} )"

src_prepare() {
	# Tango is deprecated
	sed -i -e '/^Inherits/s:Tango:gnome,&:' icons/index.theme.in || die

	# Encoding= key is obsolete
	sed -i -e '/^Encoding/d' *.theme.in || die

	use gtk || { sed -i \
		-e '/^gtk-engine/d' -e '/GTK2/d' -e '/^SUBDIRS/s:gtk-engine ::' \
		configure.in Makefile.am || die; }

	local f=po/POTFILES.skip
	echo light-index.theme.in >> ${f}
	echo dark-index.theme.in >> ${f}

	if [[ ${CHOST} == *-interix* ]] || ! use gtk; then
		eautoreconf
	fi
}

src_configure() {
	econf $(use gtk && echo --disable-static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog

	use gtk && find "${ED}"/usr -name libnimbus.la -exec rm -f {} +
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
