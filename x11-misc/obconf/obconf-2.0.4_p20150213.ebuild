# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=63ec47c5e295ad4f09d1df6d92afb7e10c3fec39
inherit autotools xdg-utils

DESCRIPTION="Tool for configuring the Openbox window manager"
HOMEPAGE="http://openbox.org/wiki/ObConf:About"
SRC_URI="http://git.openbox.org/?p=dana/obconf.git;a=snapshot;h=${COMMIT};sf=tgz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT:0:7}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
IUSE="nls"

RDEPEND="
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/startup-notification
	>=x11-wm/openbox-3.5.2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
