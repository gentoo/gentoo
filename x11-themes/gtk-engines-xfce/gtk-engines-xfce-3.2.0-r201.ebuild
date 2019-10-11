# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MY_PN=gtk-xfce-engine
inherit multilib-minimal

DESCRIPTION="A port of Xfce engine to GTK+ 2.x"
HOMEPAGE="https://git.xfce.org/xfce/gtk-xfce-engine/"
SRC_URI="https://archive.xfce.org/src/xfce/${MY_PN}/${PV%.*}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.34.3[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

S=${WORKDIR}/${MY_PN}-${PV}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	local myconf=(
		--enable-gtk2
		--disable-gtk3
	)
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
