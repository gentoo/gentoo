# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/hiawatha/hiawatha-9.8.ebuild,v 1.1 2014/10/10 20:52:19 hasufell Exp $

# ssl USE flag currently broken, unconditionally enabled
# rproxy USE flag broken too, unconditionally enabled

EAPI=5

CMAKE_MIN_VERSION="2.8.4"

inherit cmake-utils systemd user

DESCRIPTION="Advanced and secure webserver"
HOMEPAGE="http://www.hiawatha-webserver.org"
SRC_URI="http://www.hiawatha-webserver.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +cache ipv6 monitor +rewrite tomahawk +xslt"

RDEPEND="
	>=net-libs/polarssl-1.3[threads]
	xslt? (	dev-libs/libxslt
			dev-libs/libxml2 )"
DEPEND="${RDEPEND}"
PDEPEND="monitor? ( www-apps/hiawatha-monitor )"

# set this in make.conf if you want to use a different user/group
HIAWATHA_USER=${HIAWATHA_USER:-hiawatha}
HIAWATHA_GROUP=${HIAWATHA_GROUP:-hiawatha}

pkg_setup() {
	enewgroup ${HIAWATHA_GROUP}
	enewuser ${HIAWATHA_USER} -1 -1 /var/www/hiawatha ${HIAWATHA_GROUP}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-9.5-cflags.patch

	rm -r polarssl || die

	grep '#ServerId =' config/hiawatha.conf.in 1>/dev/null || die
	sed -i \
		-e "s/#ServerId =.*$/ServerId = ${HIAWATHA_USER}/" \
		config/hiawatha.conf.in || die
}

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DIR:STRING=/etc/hiawatha
		$(cmake-utils_use_enable cache CACHE)
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable ipv6 IPV6)
		$(cmake-utils_use_enable kernel_linux LOADCHECK)
		$(cmake-utils_use_enable monitor MONITOR)
		-DENABLE_SSL=YES
		$(cmake-utils_use_enable tomahawk TOMAHAWK)
		$(cmake-utils_use_enable rewrite TOOLKIT)
		$(cmake-utils_use_enable xslt XSLT)
		-DLOG_DIR:STRING=/var/log/hiawatha
		-DPID_DIR:STRING=/var/run
		-DUSE_SHARED_POLARSSL_LIBRARY=ON
		-DUSE_SYSTEM_POLARSSL=ON
		-DWEBROOT_DIR:STRING=/var/www/hiawatha
		-DWORK_DIR:STRING=/var/lib/hiawatha
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED%%/}"/var/www/hiawatha/*

	newinitd "${FILESDIR}"/hiawatha.initd hiawatha
	systemd_dounit "${FILESDIR}"/hiawatha.service

	local i
	for i in /var/{lib,log}/hiawatha ; do
		keepdir ${i}
		fowners ${HIAWATHA_USER}:${HIAWATHA_GROUP} ${i}
		fperms 0750 ${i}
	done

	keepdir /var/www/hiawatha
	fowners ${HIAWATHA_USER}:${HIAWATHA_GROUP} /var/www/hiawatha
}
