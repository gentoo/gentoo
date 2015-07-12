# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-xfce/gtk-engines-xfce-3.2.0-r300.ebuild,v 1.6 2015/07/12 09:05:24 jer Exp $

EAPI=5
MY_PN=gtk-xfce-engine
inherit xfconf multilib-minimal

DESCRIPTION="A port of Xfce engine to GTK+ 3.x"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${MY_PN}/${PV%.*}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug"

COMMON_DEPEND=">=dev-libs/glib-2.24[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r5
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	XFCONF=(
		--disable-gtk2
		--enable-gtk3
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
		xfconf_src_configure
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
}
