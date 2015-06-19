# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacious/audacious-2.5.4.ebuild,v 1.9 2015/01/29 18:52:25 mgorny Exp $

EAPI=4

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.atheme.org/${MY_P}.tar.gz
	 mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ppc ~ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="altivec chardet nls session cpu_flags_x86_sse2"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.16
	>=dev-libs/libmcs-0.7.1-r2
	>=dev-libs/libmowgli-0.9.50:0
	dev-libs/libxml2
	>=x11-libs/cairo-1.2.6
	>=x11-libs/gtk+-2.14:2
	>=x11-libs/pango-1.8.0
	session? ( x11-libs/libSM )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	chardet? ( app-i18n/libguess )
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-2.5.4"

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--enable-dbus \
		$(use_enable altivec) \
		$(use_enable chardet) \
		$(use_enable nls) \
		$(use_enable session sm) \
		$(use_enable cpu_flags_x86_sse2 sse2)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins "${WORKDIR}"/gentoo_ice/*
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}
