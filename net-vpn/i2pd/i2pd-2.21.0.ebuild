# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd user cmake-utils eapi7-ver toolchain-funcs

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI="https://github.com/PurpleI2P/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~x86"
IUSE="cpu_flags_x86_aes cpu_flags_x86_avx i2p-hardening libressl static +upnp websocket"

# if using libressl, require >=boost-1.65, see #597798
RDEPEND="
	!static? (
		dev-libs/boost[threads]
		!libressl? ( dev-libs/openssl:0[-bindist] )
		libressl? (
			dev-libs/libressl:0
			>=dev-libs/boost-1.65
		)
		upnp? ( net-libs/miniupnpc )
	)"
DEPEND="${RDEPEND}
	static? (
		dev-libs/boost[static-libs,threads]
		!libressl? ( dev-libs/openssl:0[static-libs] )
		libressl? (
			dev-libs/libressl:0[static-libs]
			>=dev-libs/boost-1.65
		)
		sys-libs/zlib[static-libs]
		upnp? ( net-libs/miniupnpc[static-libs] )
	)
	websocket? ( dev-cpp/websocketpp )"

I2PD_USER=i2pd
I2PD_GROUP=i2pd

CMAKE_USE_DIR="${S}/build"

DOCS=( README.md contrib/i2pd.conf contrib/tunnels.conf )

PATCHES=( "${FILESDIR}/${PN}-2.14.0-fix_installed_components.patch" )

pkg_pretend() {
	if tc-is-gcc && ! ver_test "$(gcc-version)" -ge "4.7"; then
		die "At least gcc 4.7 is required"
	fi
	if use i2p-hardening && ! tc-is-gcc; then
		die "i2p-hardening requires gcc"
	fi
}

src_configure() {
	mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
		-DWITH_PCH=OFF
		-DWITH_STATIC=$(usex static ON OFF)
		-DWITH_UPNP=$(usex upnp ON OFF)
		-DWITH_WEBSOCKETS=$(usex websocket ON OFF)
		-DWITH_LIBRARY=ON
		-DWITH_BINARY=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# config
	insinto /etc/i2pd
	doins contrib/i2pd.conf
	doins contrib/tunnels.conf

	# grant i2pd group read and write access to config files
	fowners "root:${I2PD_GROUP}" \
		/etc/i2pd/i2pd.conf \
		/etc/i2pd/tunnels.conf
	fperms 660 \
		/etc/i2pd/i2pd.conf \
		/etc/i2pd/tunnels.conf

	# working directory
	keepdir /var/lib/i2pd
	insinto /var/lib/i2pd
	doins -r contrib/certificates
	fowners "${I2PD_USER}:${I2PD_GROUP}" /var/lib/i2pd/
	fperms 700 /var/lib/i2pd/

	# add /var/lib/i2pd/certificates to CONFIG_PROTECT
	doenvd "${FILESDIR}/99i2pd"

	# openrc and systemd daemon routines
	newconfd "${FILESDIR}/i2pd-2.6.0-r3.confd" i2pd
	newinitd "${FILESDIR}/i2pd-2.6.0-r3.initd" i2pd
	systemd_newunit "${FILESDIR}/i2pd-2.6.0-r3.service" i2pd.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/i2pd-2.6.0-r3.logrotate" i2pd
}

pkg_setup() {
	enewgroup "${I2PD_GROUP}"
	enewuser "${I2PD_USER}" -1 -1 /var/lib/run/i2pd "${I2PD_GROUP}"
}

pkg_postinst() {
	if [[ -f ${EROOT%/}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}
