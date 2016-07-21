# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils readme.gentoo versionator

MAJOR_VER="$(get_version_component_range 1-2)"

DESCRIPTION="Lightweight X11 desktop panel for LXDE"
HOMEPAGE="http://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/LXPanel%20%28desktop%20panel%29/LXPanel%20${MAJOR_VER}.x/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="+alsa wifi"
RESTRICT="test"  # bug 249598

RDEPEND="dev-libs/keybinder:0=
	x11-libs/gtk+:2
	>=x11-libs/libfm-1.2.0[gtk]
	x11-libs/libwnck:1
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/libX11
	lxde-base/lxmenu-data
	lxde-base/menu-cache
	alsa? ( media-libs/alsa-lib )
	wifi? ( net-wireless/wireless-tools )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

DOC_CONTENTS="If you have problems with broken icons shown in the main panel,
you will have to configure panel settings via its menu.
This will not be an issue with first time installations."

src_prepare() {
	#bug #415595
	sed -i "s:-Werror::" configure.ac || die
	eautoreconf
}

src_configure() {
	local plugins="netstatus,volume,cpu,deskno,batt, \
		kbled,xkb,thermal,cpufreq,monitors"

	use wifi && plugins+=",netstat"
	use alsa && plugins+=",volumealsa"
	[[ ${CHOST} == *-interix* ]] && plugins=deskno,kbled,xkb

	econf $(use_enable alsa) --with-x --with-plugins="${plugins}"
	# the gtk+ dep already pulls in libX11, so we might as well hardcode with-x
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README

	# Get rid of the .la files.
	find "${D}" -name '*.la' -delete

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
