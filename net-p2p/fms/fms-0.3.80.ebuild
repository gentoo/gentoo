# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils cmake-utils user

DESCRIPTION="A spam-resistant message board application for Freenet"
HOMEPAGE="http://freenetproject.org/tools.html"
SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="frost ssl"

RDEPEND="virtual/libiconv
	frost? ( net-libs/mbedtls )
	ssl? ( net-libs/mbedtls )
	>=dev-libs/poco-1.4.3_p1
	>=dev-db/sqlite-3.6.15"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}
PATCHES=( "${FILESDIR}"/${PN}-use-system-libs4.patch )

pkg_setup() {
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_prepare() {
	rm -rv  libs
	edos2unix src/http/pages/showfilepage.cpp
	edos2unix CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=( -DI_HAVE_READ_THE_README=ON \
		-DUSE_BUNDLED_SQLITE=OFF \
		-DDO_CHARSET_CONVERSION=ON \
		-DFROST_SUPPORT=$(use frost && echo ON || echo OFF) \
		-DFCP_SSL_SUPPORT=$(use ssl && echo ON || echo OFF) )
	cmake-utils_src_configure
}

src_install() {
	insinto /var/freenet/fms
	dobin "${CMAKE_BUILD_DIR}"/fms
	doins *.htm
	doins -r fonts images styles translations
	fperms -R o-rwx /var/freenet/fms/ /usr/bin/fms
	fowners -R freenet:freenet /var/freenet/fms/ /usr/bin/fms
	doinitd "${FILESDIR}/fms"
	dodoc readme.txt
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
