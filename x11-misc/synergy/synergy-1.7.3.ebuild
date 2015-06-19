# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/synergy/synergy-1.7.3.ebuild,v 1.2 2015/06/02 05:01:37 jer Exp $

EAPI=5
inherit eutils flag-o-matic gnome2-utils cmake-utils qt4-r2

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="http://synergy-project.org/ https://github.com/synergy/synergy"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}-stable.tar.gz -> ${P}.tar.gz
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="qt4 test"

S=${WORKDIR}/${P}-stable

COMMON_DEPEND="
	dev-libs/openssl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		net-dns/avahi[mdnsresponder-compat]
	)
"
DEPEND="
	${COMMON_DEPEND}
	test? ( >=dev-cpp/gmock-1.6.0 )
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
"
RDEPEND="
	${COMMON_DEPEND}
	qt4? ( !x11-misc/qsynergy )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.16_p1969-pthread.patch"
	"${FILESDIR}/${PN}-1.4.17_p2055-test.patch"
	"${FILESDIR}/${PN}-1.4.17_p2055-gentoo.patch"
	"${FILESDIR}/${PN}-1.4.17_p2055-CSocketMultiplexer.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=$(cmake-utils_use_with test GENTOO_TEST)
	cmake-utils_src_configure

	if use qt4 ; then
		cd src/gui || die
		qt4-r2_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use qt4 ; then
		cd src/gui || die
		qt4-r2_src_compile
	fi
}

src_test() {
	local exe fail
	for exe in bin/integtests bin/unittests; do
		${exe} || fail+=" ${exe}"
	done
	[[ ${fail} ]] && ewarn "${fail} failed"
}

src_install () {
	dobin bin/${PN}{c,s} bin/syntool

	if use qt4 ; then
		newbin bin/${PN} qsynergy
		newicon -s 256 "${DISTDIR}"/${PN}.png q${PN}.png
		make_desktop_entry q${PN} ${PN/s/S} q${PN} Utility;
	fi

	insinto /etc
	newins doc/synergy.conf.example synergy.conf

	newman doc/${PN}c.man ${PN}c.1
	newman doc/${PN}s.man ${PN}s.1

	dodoc README doc/synergy.conf.example* ChangeLog
}

pkg_preinst() {
	use qt4 && gnome2_icon_savelist
}

pkg_postinst() {
	use qt4 && gnome2_icon_cache_update
}

pkg_postrm() {
	use qt4 && gnome2_icon_cache_update
}
