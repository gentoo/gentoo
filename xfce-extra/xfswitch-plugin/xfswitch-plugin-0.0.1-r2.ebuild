# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib xfconf

DESCRIPTION="A panel plug-in for user switching (using lightdm or gdm or ldm)"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfswitch-plugin"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gdm lightdm lxdm"

REQUIRED_USE="
	gdm? (
		!lightdm
		!lxdm
	)

	lightdm? (
		!gdm
		!lxdm
	)
	lxdm? (
		!gdm
		!lightdm
	)
"

COMMON_DEPEND=">=x11-libs/gtk+-2.12:2
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/libxfcegui4-4.8
	>=xfce-base/xfce4-panel-4.8"
RDEPEND="${COMMON_DEPEND}
	gdm? ( gnome-base/gdm )
	lightdm? ( x11-misc/lightdm )
	lxdm? ( lxde-base/lxdm )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}

src_prepare() {
	if use lightdm; then #411921, 526598
		sed -i \
			-e '/command/s:gdmflexiserver --new:/usr/bin/dm-tool switch-to-greeter:' \
			panel-plugin/main.c || die
	elif use lxdm; then
		sed -i \
			-e '/command/s:gdmflexiserver --new:/usr/sbin/lxdm -c USER_SWITCH:' \
			panel-plugin/main.c || die
	fi

	xfconf_src_prepare
}
