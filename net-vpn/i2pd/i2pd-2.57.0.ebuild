# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI="https://github.com/PurpleI2P/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test +upnp"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/boost:=
	dev-libs/openssl:0=[-bindist(-)]
	sys-libs/zlib
	upnp? ( net-libs/miniupnpc:= )
"
RDEPEND="
	acct-user/i2pd
	acct-group/i2pd
	${DEPEND}
"

CMAKE_USE_DIR="${WORKDIR}/${P}/build"

DOCS=( ../README.md ../contrib/i2pd.conf ../contrib/tunnels.conf )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DWITH_HARDENING=OFF # worsens or matches the non-hardened profiles
		-DWITH_STATIC=OFF
		-DWITH_UPNP=$(usex upnp ON OFF)
		-DWITH_LIBRARY=ON
		-DWITH_BINARY=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# config
	insinto /etc/i2pd
	doins contrib/i2pd.conf
	doins contrib/tunnels.conf

	# working directory
	insinto /var/lib/i2pd
	doins -r contrib/certificates

	# add /var/lib/i2pd/certificates to CONFIG_PROTECT
	doenvd "${FILESDIR}/99i2pd"

	# openrc and systemd daemon routines
	newconfd "${FILESDIR}/i2pd-2.56.0.confd" i2pd
	newinitd "${FILESDIR}/i2pd-2.56.0.initd" i2pd
	systemd_newunit "${FILESDIR}/i2pd-2.38.0.service" i2pd.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/i2pd-2.57.0.logrotate" i2pd
}

pkg_postinst() {
	if [[ -f ${EROOT}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}
