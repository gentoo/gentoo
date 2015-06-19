# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxtask/lxtask-0.1.4-r1.ebuild,v 1.5 2013/12/26 14:40:26 maekke Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="LXDE Task manager"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ppc x86 ~arm-linux ~x86-linux"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

src_prepare() {
	# use new patch to remove broken linguas
	epatch "${FILESDIR}"/${P}-remove-broken-linguas.patch

	# bug #485348
	epatch "${FILESDIR}"/${P}-sandbox.patch

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README ChangeLog
}
