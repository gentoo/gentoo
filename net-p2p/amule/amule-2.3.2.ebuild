# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER="3.0"

inherit wxwidgets user

MY_P=${PN/m/M}-${PV}
S="${WORKDIR}"/${MY_P}

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="daemon debug geoip nls remote stats unicode upnp +X"

DEPEND="
	>=dev-libs/crypto++-5
	sys-libs/binutils-libs:0=
	>=sys-libs/zlib-1.2.1
	x11-libs/wxGTK:${WX_GTK_VER}[X?]
	stats? ( >=media-libs/gd-2.0.26:=[jpeg] )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0:0=
	unicode? ( >=media-libs/gd-2.0.26:= ) )
	!net-p2p/imule
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.6-fallocate.diff
)

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
		--with-denoise-level=0 \
		--with-wx-config="${WX_CONFIG}" \
		--enable-amulecmd \
		--without-boost \
		$(use_enable debug) \
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
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
