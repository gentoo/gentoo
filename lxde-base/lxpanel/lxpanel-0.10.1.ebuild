# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 xdg

DESCRIPTION="Lightweight X11 desktop panel for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXPanel"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+alsa wifi"

RDEPEND="
	dev-libs/keybinder:3
	lxde-base/lxmenu-data
	>=lxde-base/menu-cache-1.1.0-r1
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	>=x11-libs/libfm-1.3.2[gtk]
	x11-libs/libwnck:3
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXpm
	alsa? ( media-libs/alsa-lib )
	wifi? ( net-wireless/wireless-tools )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

DOC_CONTENTS="If you have problems with broken icons shown in the main panel,
you will have to configure panel settings via its menu.
This will not be an issue with first time installations."

PATCHES=(
	# https://sourceforge.net/p/lxde/bugs/773/
	"${FILESDIR}/${P}-fix-pager-panel-width.patch"
)

src_configure() {
	local plugins="netstatus,volume,cpu,deskno,batt,kbled,xkb,thermal,cpufreq,monitors"

	use wifi && plugins+=",netstat"
	use alsa && plugins+=",volumealsa"
	[[ ${CHOST} == *-interix* ]] && plugins=deskno,kbled,xkb

	econf \
		$(use_enable alsa) \
		--enable-gtk3 \
		--with-x \
		--with-plugins="${plugins}"
	# the gtk+ dep already pulls in libX11, so we might as well hardcode with-x
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
