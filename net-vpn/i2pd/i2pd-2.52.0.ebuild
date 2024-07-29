# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs systemd

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI="https://github.com/PurpleI2P/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cpu_flags_x86_aes i2p-hardening +upnp"

RDEPEND="
	acct-user/i2pd
	acct-group/i2pd
	dev-libs/boost:=
	dev-libs/openssl:0=[-bindist(-)]
	sys-libs/zlib
	upnp? ( net-libs/miniupnpc:= )"
DEPEND="${RDEPEND}"

CMAKE_USE_DIR="${WORKDIR}/${P}/build"

DOCS=( ../README.md ../contrib/i2pd.conf ../contrib/tunnels.conf )

PATCHES=( "${FILESDIR}/${P}-miniupnp.patch" )

pkg_pretend() {
	if use i2p-hardening && ! tc-is-gcc; then
		die "i2p-hardening requires gcc"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
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
	newconfd "${FILESDIR}/i2pd-2.6.0-r3.confd" i2pd
	newinitd "${FILESDIR}/i2pd-2.39.0.initd" i2pd
	systemd_newunit "${FILESDIR}/i2pd-2.38.0.service" i2pd.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/i2pd-2.38.0-r1.logrotate" i2pd
}

pkg_postinst() {
	if [[ -f ${EROOT}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}
