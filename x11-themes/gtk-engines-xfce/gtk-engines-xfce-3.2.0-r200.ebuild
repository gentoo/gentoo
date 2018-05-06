# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_PN=gtk-xfce-engine
inherit xfconf multilib-minimal

DESCRIPTION="A port of Xfce engine to GTK+ 2.x"
HOMEPAGE="https://git.xfce.org/xfce/gtk-xfce-engine/"
SRC_URI="mirror://xfce/src/xfce/${MY_PN}/${PV%.*}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	XFCONF=(
		--disable-gtk3
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
