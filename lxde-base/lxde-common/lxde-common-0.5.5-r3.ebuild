# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxde-common/lxde-common-0.5.5-r3.ebuild,v 1.3 2015/03/03 08:01:17 dlan Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="LXDE Session default configuration files and nuoveXT2 iconset"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86 ~arm-linux ~x86-linux"
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
	fperms 755 /etc/X11/Sessions/lxde
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	elog "${P} has renamed the configuration file name to"
	elog "/etc/xdg/lxsession/LXDE/desktop.conf"
	elog "Keep in mind you have to migrate your custom settings"
	elog "from /etc/xdg/lxsession/LXDE/config"
}
