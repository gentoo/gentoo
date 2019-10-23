# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Synchronous multi-room audio player"
HOMEPAGE="https://github.com/badaix/snapcast"

if [[ ${PV} == *9999 ]] ; then
	inherit cmake-utils systemd git-r3

	EGIT_REPO_URI="https://github.com/badaix/snapcast.git"
	EGIT_BRANCH="develop"
else
	inherit cmake-utils systemd

	SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+client +flac +server static-libs tremor +vorbis +zeroconf"

REQUIRED_USE="|| ( server client )"

RDEPEND="client? (
		acct-user/snapclient
		media-libs/alsa-lib
	)
	flac? ( media-libs/flac )
	server? ( acct-user/snapserver )
	tremor? ( media-libs/tremor )
	vorbis? ( media-libs/libvorbis )
	zeroconf? ( net-dns/avahi[dbus] )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.70:="

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_WITH_FLAC=$(usex flac)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTS=no
		-DBUILD_WITH_TREMOR=$(usex tremor)
		-DBUILD_WITH_VORBIS=$(usex vorbis)
		-DBUILD_WITH_AVAHI=$(usex zeroconf)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	for bin in server client ; do
		if use ${bin} ; then
			doman "${bin}/snap${bin}.1"

			newinitd "${FILESDIR}/snap${bin}.initd" "snap${bin}"

			systemd_dounit "${FILESDIR}/snap${bin}.service"
		fi
	done

	if use client ; then
		newconfd "${FILESDIR}/snapclient.confd" "snapclient"
	fi

	if use server ; then
		newconfd "${FILESDIR}/snapserver-0.16.0.confd" "snapserver"

		insinto /etc
		doins "${S}"/server/etc/snapserver.conf
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "With Snapcast v0.16.0, the server configuration moved to"
		elog "/etc/snapserver.conf. Please add your pipes to this file."
	fi
}
