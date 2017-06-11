# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/qxmpp-project/qxmpp"

inherit git-r3 qmake-utils

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework"
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc opus +speex test theora vpx"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	vpx? ( media-libs/libvpx )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare(){
	if ! use doc; then
		sed -i \
			-e '/SUBDIRS/s/doc//' \
			-e '/INSTALLS/d' \
			qxmpp.pro || die "sed for removing docs failed"
	fi
	if ! use test; then
		sed -i -e '/SUBDIRS/s/tests//' \
			qxmpp.pro || die "sed for removing tests failed"
	fi
	# There is no point in building examples. Also, they require dev-qt/qtgui
	sed -i -e '/SUBDIRS/s/examples//' \
			qxmpp.pro || die "sed for removing examples failed"
	default_src_prepare
}

src_configure(){
	local conf_speex
	local conf_theora
	local conf_vpx

	use opus && conf_opus="QXMPP_USE_OPUS=1"
	use speex && conf_speex="QXMPP_USE_SPEEX=1"
	use theora && conf_theora="QXMPP_USE_THEORA=1"
	use vpx && conf_vpx="QXMPP_USE_VPX=1"

	eqmake5 "${S}"/qxmpp.pro "PREFIX=${EPREFIX}/usr" "LIBDIR=$(get_libdir)" "${conf_opus}" "${conf_speex}" "${conf_theora}" "${conf_vpx}"
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
