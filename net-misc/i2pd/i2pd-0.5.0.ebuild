# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/i2pd/i2pd-0.5.0.ebuild,v 1.2 2015/02/02 17:06:04 mgorny Exp $

EAPI=5
inherit eutils systemd user cmake-utils

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PrivacySolutions/i2pd"
SRC_URI="https://github.com/PrivacySolutions/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_aes i2p-hardening static"

RDEPEND="!static? ( >=dev-libs/boost-1.46[threads] )
	!static? ( dev-libs/crypto++ )"
DEPEND="${RDEPEND}
	static? ( >=dev-libs/boost-1.46[static-libs,threads] )
	static? ( dev-libs/crypto++[static-libs] )
	>=dev-util/cmake-2.8
	i2p-hardening? ( >=sys-devel/gcc-4.6 )
	|| ( >=sys-devel/gcc-4.6 >=sys-devel/clang-3.3 )"

I2PD_USER="${I2PD_USER:-i2pd}"
I2PD_GROUP="${I2PD_GROUP:-i2pd}"

CMAKE_USE_DIR="${S}/build"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with cpu_flags_x86_aes AESNI)
		$(cmake-utils_use_with i2p-hardening HARDENING)
		$(cmake-utils_use_with static STATIC)
		-D WITH_LIBRARY=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doman "${FILESDIR}/${PN}.1"
	keepdir /var/lib/i2pd/
	fowners "${I2PD_USER}:${I2PD_GROUP}" /var/lib/i2pd/
	fperms 700 /var/lib/i2pd/
	insinto /etc/
	doins "${FILESDIR}/${PN}.conf"
	fowners "${I2PD_USER}:${I2PD_GROUP}" "/etc/${PN}.conf"
	fperms 600 "/etc/${PN}.conf"
	dodir /usr/share/i2pd
	cp -R "${S}/contrib/certificates" "${D}/var/lib/i2pd" || die "Install failed!"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	doenvd "${FILESDIR}/99${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
}

pkg_setup() {
	enewgroup "${I2PD_GROUP}"
	enewuser "${I2PD_USER}" -1 -1 "/var/lib/run/${PN}" "${I2PD_GROUP}"
}
