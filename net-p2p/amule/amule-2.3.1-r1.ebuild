# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"

inherit eutils flag-o-matic wxwidgets user

MY_P=${PN/m/M}-${PV}
S="${WORKDIR}"/${MY_P}

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="daemon debug geoip nls remote stats unicode upnp +X"

RDEPEND="
	>=dev-libs/crypto++-5
	>=sys-libs/zlib-1.2.1
	stats? ( >=media-libs/gd-2.0.26[jpeg] )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0:0=
	unicode? ( >=media-libs/gd-2.0.26 ) )
	X? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	!X? ( x11-libs/wxGTK:${WX_GTK_VER} )
	!net-p2p/imule
"
DEPEND="${RDEPEND}"

pkg_setup() {
	if use stats && ! use X; then
		einfo "Note: You would need both the X and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi
}

pkg_preinst() {
	if use daemon || use remote; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2.6-fallocate.diff
	# Bug 412371
	epatch "${FILESDIR}"/${PN}-2.3.1-gcc47.patch

	# https://bugs.gentoo.org/show_bug.cgi?id=465084
	epatch "${FILESDIR}"/${PN}-2.3.1-wx3.0.patch
	epatch "${FILESDIR}"/${PN}-2.3.1-build.patch
}

src_configure() {
	local myconf

	if use X; then
		einfo "wxGTK with X support will be used"
		need-wxwidgets unicode
	else
		einfo "wxGTK without X support will be used"
		need-wxwidgets base-unicode
	fi

	if use X ; then
		use stats && myconf="${myconf}
			--enable-wxcas
			--enable-alc"
		use remote && myconf="${myconf}
			--enable-amule-gui"
	else
		myconf="
			--disable-monolithic
			--disable-amule-gui
			--disable-wxcas
			--disable-alc"
	fi

	econf \
		--with-wx-config=${WX_CONFIG} \
		--enable-amulecmd \
		$(use_enable debug) \
		$(use_enable !debug optimize) \
		$(use_enable daemon amule-daemon) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable remote webserver) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
