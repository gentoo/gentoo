# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/xarchiver/xarchiver-0.5.4.ebuild,v 1.1 2015/04/21 04:04:46 calchan Exp $

EAPI=5
inherit xfconf

DESCRIPTION="a GTK+ based and advanced archive manager that can be used with Thunar"
HOMEPAGE="http://xarchiver.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.24:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${PN}-0.5.3-add-mime-types.patch
		"${FILESDIR}"/${PN}-0.5.3-fix-password-protected.patch
		"${FILESDIR}"/${PN}-0.5.3-fix-rpm-support.patch
		)

	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog README TODO )
}

src_prepare() {
	sed -e '/COPYING/d' -e '/NEWS/d' -i doc/Makefile.in || die
	xfconf_src_prepare
}

src_install() {
	xfconf_src_install DOCDIR="${ED}/usr/share/doc/${PF}"
}

pkg_postinst() {
	xfconf_pkg_postinst
	elog "You need external programs for some formats, including:"
	elog "7zip - app-arch/p7zip"
	elog "arj - app-arch/unarj app-arch/arj"
	elog "lha - app-arch/lha"
	elog "lzop - app-arch/lzop"
	elog "rar - app-arch/unrar app-arch/rar"
	elog "zip - app-arch/unzip app-arch/zip"
}
