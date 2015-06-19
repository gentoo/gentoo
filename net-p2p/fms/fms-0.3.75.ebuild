# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/fms/fms-0.3.75.ebuild,v 1.1 2015/04/24 12:55:59 tommy Exp $

EAPI="5"

inherit eutils cmake-utils user

DESCRIPTION="A spam-resistant message board application for Freenet"
HOMEPAGE="http://freenetproject.org/tools.html"
SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="frost"

RDEPEND="virtual/libiconv
	frost? ( net-libs/polarssl )
	>=dev-libs/poco-1.4.3_p1
	>=dev-db/sqlite-3.6.15"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_prepare() {
	edos2unix src/http/pages/showfilepage.cpp
	epatch "${FILESDIR}"/${PN}-use-system-libs2.patch
}

src_configure() {
	local mycmakeargs="-DI_HAVE_READ_THE_README=ON \
		-DUSE_BUNDLED_SQLITE=OFF \
		-DDO_CHARSET_CONVERSION=ON \
		$(cmake-utils_use frost FROST_SUPPORT)"
	cmake-utils_src_configure
}

src_install() {
	insinto /var/freenet/fms
	dobin "${CMAKE_BUILD_DIR}"/fms || die
	doins *.htm || die "doinstall failed"
	doins -r fonts images styles translations || die
	fperms -R o-rwx /var/freenet/fms/ /usr/bin/fms
	fowners -R freenet:freenet /var/freenet/fms/ /usr/bin/fms
	doinitd "${FILESDIR}/fms" || die "installing init.d file failed"
	dodoc readme.txt || die "installing doc failed"
}

pkg_postinst() {
	if ! has_version 'net-p2p/freenet' ; then
		ewarn "FMS needs a freenet node to up-/download #ssages."
		ewarn "Please make sure to have a node you can connect to"
		ewarn "or install net-p2p/freenet to get FMS working."
	fi
	elog "By default, the FMS NNTP server will listen on port 1119,"
	elog "and the web configuration interface will be running at"
	elog "http://localhost:8080. For more information, read"
	elog "${ROOT}usr/share/doc/${PF}/readme.txt.bz2"
	if use frost; then
		elog " "
		elog "You need to enable frost on the config page"
		elog "and restart fms for frost support."
	fi
}
