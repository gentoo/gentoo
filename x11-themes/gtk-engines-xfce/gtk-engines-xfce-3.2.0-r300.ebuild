# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_PN=gtk-xfce-engine
inherit xfconf multilib-minimal

DESCRIPTION="A port of Xfce engine to GTK+ 3.x"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${MY_PN}/${PV%.*}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.24[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
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
