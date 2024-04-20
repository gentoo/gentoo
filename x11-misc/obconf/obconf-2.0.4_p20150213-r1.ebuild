# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

HASH_OBCONF=63ec47c5e295ad4f09d1df6d92afb7e10c3fec39

DESCRIPTION="Tool for configuring the Openbox window manager"
HOMEPAGE="http://openbox.org/wiki/ObConf:About"
SRC_URI="http://git.openbox.org/?p=dana/obconf.git;a=snapshot;h=${HASH_OBCONF};sf=tgz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH_OBCONF::7}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86 ~x86-linux"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/startup-notification
	x11-wm/openbox:3"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
