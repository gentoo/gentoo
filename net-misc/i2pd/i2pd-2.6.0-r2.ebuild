# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils systemd user cmake-utils

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI="https://github.com/PurpleI2P/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cpu_flags_x86_aes i2p-hardening libressl pch static +upnp"

RDEPEND="!static? ( >=dev-libs/boost-1.49[threads]
			dev-libs/crypto++
			!libressl? ( dev-libs/openssl:0 )
			libressl? ( dev-libs/libressl )
			upnp? ( net-libs/miniupnpc )
		)"
DEPEND="${RDEPEND}
	static? ( >=dev-libs/boost-1.49[static-libs,threads]
		dev-libs/crypto++[static-libs]
		!libressl? ( dev-libs/openssl:0[-bindist,static-libs] )
		libressl? ( dev-libs/libressl[static-libs] )
		upnp? ( net-libs/miniupnpc[static-libs] ) )
	i2p-hardening? ( >=sys-devel/gcc-4.7 )
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.3 )"

I2PD_USER="${I2PD_USER:-i2pd}"
I2PD_GROUP="${I2PD_GROUP:-i2pd}"

CMAKE_USE_DIR="${S}/build"

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.5.1-fix_installed_components.patch"
	eapply_user
}

src_configure() {
	mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
		-DWITH_PCH=$(usex pch ON OFF)
		-DWITH_STATIC=$(usex static ON OFF)
		-DWITH_UPNP=$(usex upnp ON OFF)
		-DWITH_LIBRARY=ON
		-DWITH_BINARY=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README.md
	keepdir /var/lib/i2pd/
	insinto "/var/lib/i2pd"
	doins -r "${S}/contrib/certificates"
	dosym /etc/i2pd/subscriptions.txt /var/lib/i2pd/subscriptions.txt
	fowners "${I2PD_USER}:${I2PD_GROUP}" /var/lib/i2pd/
	fperms 700 /var/lib/i2pd/
	dodir "/etc/${PN}"
	insinto "/etc/${PN}"
	doins "${S}/docs/${PN}.conf"
	doins "${S}/debian/subscriptions.txt"
	doins "${S}/debian/tunnels.conf"
	dodir /usr/share/i2pd
	newconfd "${FILESDIR}/${PN}-2.6.0-r2.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}-2.6.0-r2.initd" "${PN}"
	systemd_newunit "${FILESDIR}/${PN}-2.6.0-r2.service" "${PN}.service"
	doenvd "${FILESDIR}/99${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}-2.5.0.logrotate" "${PN}"
	fowners "${I2PD_USER}:${I2PD_GROUP}" "/etc/${PN}/${PN}.conf" \
		"/etc/${PN}/subscriptions.txt" \
		"/etc/${PN}/tunnels.conf"
	fperms 600 "/etc/${PN}/${PN}.conf" \
		"/etc/${PN}/subscriptions.txt" \
		"/etc/${PN}/tunnels.conf"
}

pkg_setup() {
	enewgroup "${I2PD_GROUP}"
	enewuser "${I2PD_USER}" -1 -1 "/var/lib/run/${PN}" "${I2PD_GROUP}"
}
