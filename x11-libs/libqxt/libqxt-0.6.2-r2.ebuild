# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qt4-r2

DESCRIPTION="The Qt eXTension library provides cross-platform utility classes for the Qt toolkit"
HOMEPAGE="http://libqxt.org/"
SRC_URI="http://dev.libqxt.org/libqxt/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="|| ( CPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="berkdb debug doc sql web xscreensaver zeroconf"

COMMON_DEPEND="
	dev-qt/qtcore:4[ssl]
	|| (
		( >=dev-qt/qtgui-4.8.5:4 dev-qt/designer:4 )
		<dev-qt/qtgui-4.8.5:4
	)
	x11-libs/libXrandr
	berkdb? ( >=sys-libs/db-4.6 )
	sql? ( dev-qt/qtsql:4 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${COMMON_DEPEND}
	doc? ( dev-qt/qthelp:4 )
"
RDEPEND="${COMMON_DEPEND}
	xscreensaver? ( x11-libs/libXScrnSaver )
"

S=${WORKDIR}/${PN}-${PN}-v${PV}

DOCS=( AUTHORS CHANGES README )
PATCHES=(
	"${FILESDIR}/${PN}-use-system-qdoc3.patch"
	"${FILESDIR}/${PN}-invoke-prev-filter.patch"	# bug 494448
	"${FILESDIR}/${PN}-media-keys.patch"		# bug 495984
	"${FILESDIR}/${PN}-xrandr-missing-lib.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	# remove insecure runpath
	sed -i -e '/^QMAKE_RPATHDIR /d' src/qxtlibs.pri || die
}

src_configure() {
	# custom configure script
	local myconf=(
		./configure -verbose
		-prefix "${EPREFIX}/usr"
		-libdir "${EPREFIX}/usr/$(get_libdir)"
		-docdir "${EPREFIX}/usr/share/doc/${PF}"
		-qmake-bin "${EPREFIX}/usr/bin/qmake"
		$(use debug && echo -debug || echo -release)
		$(use berkdb || echo -no-db -nomake berkeley)
		$(use doc || echo -nomake docs)
		$(use sql || echo -nomake sql)
		$(use web || echo -nomake web)
		$(use zeroconf || echo -no-zeroconf -nomake zeroconf)
	)
	echo "${myconf[@]}"
	"${myconf[@]}" || die "./configure failed"

	eqmake4 -recursive
}

src_compile() {
	qt4-r2_src_compile

	use doc && emake docs
}

pkg_postinst() {
	if use doc; then
		einfo
		einfo "In case you want to browse ${PN} documentation using"
		einfo "Qt Assistant, perform the following steps:"
		einfo "  1. Open the Assistant"
		einfo "  2. Edit -> Preferences -> Documentation -> Add"
		einfo "  3. Add this path: ${EPREFIX}/usr/share/doc/${PF}/qxt.qch"
		einfo
	fi
}
