# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="debug doc opus +speex test theora vpx"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	vpx? ( media-libs/libvpx:= )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	default

	if ! use doc; then
		sed -e '/SUBDIRS/s/doc//' \
			-e '/INSTALLS/d' \
			-i qxmpp.pro || die "failed to remove docs"
	fi
	if ! use test; then
		sed -e '/SUBDIRS/s/tests//' \
			-i qxmpp.pro || die "failed to remove tests"
	else
		# requires network connection, bug #623708
		sed -e "/qxmppiceconnection/d" \
			-i tests/tests.pro || die "failed to drop single test"
	fi
	# There is no point in building examples. Also, they require dev-qt/qtgui
	sed -e '/SUBDIRS/s/examples//' \
		-i qxmpp.pro || die "sed for removing examples failed"
}

src_configure() {
	eqmake5 "${S}"/qxmpp.pro \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="$(get_libdir)" \
		QXMPP_USE_OPUS=$(usex opus 1 '') \
		QXMPP_USE_SPEEX=$(usex speex 1 '') \
		QXMPP_USE_THEORA=$(usex theora 1 '') \
		QXMPP_USE_VPX=$(usex vpx 1 '')
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	if use doc; then
		# Use proper path for documentation
		mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die "doc mv failed"
	fi
}

src_test() {
	MAKEOPTS="-j1" # random tests fail otherwise
	default_src_test
}
