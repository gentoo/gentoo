# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs systemd

DESCRIPTION="A C++ daemon for accessing the I2P anonymous network"
HOMEPAGE="https://github.com/PurpleI2P/i2pd"
SRC_URI="https://github.com/PurpleI2P/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cpu_flags_x86_aes cpu_flags_x86_avx i2p-hardening libressl static +upnp"

RDEPEND="
	acct-user/i2pd
	acct-group/i2pd
	!static? (
		dev-libs/boost:=[threads]
		!libressl? ( dev-libs/openssl:0=[-bindist] )
		libressl? ( dev-libs/libressl:0= )
		upnp? ( net-libs/miniupnpc:= )
	)"
DEPEND="${RDEPEND}
	static? (
		dev-libs/boost:=[static-libs,threads]
		sys-libs/zlib[static-libs]
		!libressl? ( dev-libs/openssl:0=[static-libs] )
		libressl? ( dev-libs/libressl:0=[static-libs] )
		upnp? ( net-libs/miniupnpc:=[static-libs] )
	)"

CMAKE_USE_DIR="${S}/build"

DOCS=( README.md contrib/i2pd.conf contrib/tunnels.conf )

PATCHES=(
	"${FILESDIR}/i2pd-2.25.0-lib-path.patch"
)

pkg_pretend() {
	if use i2p-hardening && ! tc-is-gcc; then
		die "i2p-hardening requires gcc"
	fi
}

src_configure() {
	mycmakeargs=(
		-DWITH_AESNI=$(usex cpu_flags_x86_aes ON OFF)
		-DWITH_HARDENING=$(usex i2p-hardening ON OFF)
		-DWITH_PCH=OFF
		-DWITH_STATIC=$(usex static ON OFF)
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
	newinitd "${FILESDIR}/i2pd-2.6.0-r3.initd" i2pd
	systemd_newunit "${FILESDIR}/i2pd-2.6.0-r3.service" i2pd.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/i2pd-2.6.0-r3.logrotate" i2pd
}

pkg_postinst() {
	if [[ -f ${EROOT}/etc/i2pd/subscriptions.txt ]]; then
		ewarn
		ewarn "Configuration of the subscriptions has been moved from"
		ewarn "subscriptions.txt to i2pd.conf. We recommend updating"
		ewarn "i2pd.conf accordingly and deleting subscriptions.txt."
	fi
}
