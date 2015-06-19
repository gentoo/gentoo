# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxde-common/lxde-common-0.5.5-r2.ebuild,v 1.6 2012/08/14 22:11:53 johu Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="LXDE Session default configuration files and nuoveXT2 iconset"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"
PDEPEND="lxde-base/lxde-icon-theme"

src_prepare() {
	#bug 380043
	epatch "${FILESDIR}"/${P}-logout.patch

	# Rerun autotools
	einfo "Regenerating autotools files..."
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install
	# install session file
	insinto /etc/X11/Sessions/
	doins ${FILESDIR}/lxde
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	elog "${P} has renamed the configuration file name to"
	elog "/etc/xdg/lxsession/LXDE/desktop.conf"
	elog "Keep in mind you have to migrate your custom settings"
	elog "from /etc/xdg/lxsession/LXDE/config"
}
