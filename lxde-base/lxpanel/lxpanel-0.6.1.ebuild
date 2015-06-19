# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxpanel/lxpanel-0.6.1.ebuild,v 1.1 2013/09/18 19:09:38 hwoarang Exp $

EAPI="4"

inherit autotools eutils readme.gentoo

DESCRIPTION="Lightweight X11 desktop panel for LXDE"
HOMEPAGE="http://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/LXPanel%20%28desktop%20panel%29/LXPanel%20${PV}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="+alsa wifi"
RESTRICT="test"  # bug 249598

RDEPEND="x11-libs/gtk+:2
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
	epatch "${FILESDIR}"/${PN}-0.5.9-sandbox.patch
	#bug #415595
	epatch "${FILESDIR}"/${PN}-0.5.9-libwnck-check.patch
	#bug #420583
	sed -i "s:-Werror::" configure.ac || die
	eautoreconf
}

src_configure() {
	local plugins="netstatus,volume,cpu,deskno,batt, \
		kbled,xkb,thermal,cpufreq,monitors"

	# wnckpager disabled per bug #415519
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
