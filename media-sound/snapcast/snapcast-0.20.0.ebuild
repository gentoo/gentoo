# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Synchronous multi-room audio player"
HOMEPAGE="https://github.com/badaix/snapcast"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/badaix/snapcast.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+client +expat +flac +opus +server static-libs tremor +vorbis +zeroconf"

REQUIRED_USE="|| ( server client )"

RDEPEND="client? (
		acct-user/snapclient
		media-libs/alsa-lib )
	expat? ( dev-libs/expat )
	flac? ( media-libs/flac )
	opus? ( media-libs/opus )
	server? (
		acct-group/snapserver
		acct-user/snapserver )
	tremor? ( media-libs/tremor )
	vorbis? ( media-libs/libvorbis )
	zeroconf? ( net-dns/avahi[dbus] )"
DEPEND="${RDEPEND}
	>=dev-cpp/aixlog-1.2.1
	>=dev-cpp/asio-1.12.1
	>=dev-cpp/popl-1.2.0"

PATCHES=( "${FILESDIR}"/${P}-gcc-11.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_WITH_EXPAT=$(usex expat)
		-DBUILD_WITH_FLAC=$(usex flac)
		-DBUILD_WITH_OPUS=$(usex opus)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTS=no
		-DBUILD_WITH_TREMOR=$(usex tremor)
		-DBUILD_WITH_VORBIS=$(usex vorbis)
		-DBUILD_WITH_AVAHI=$(usex zeroconf)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	for bin in server client ; do
		if use ${bin} ; then
			doman "${bin}/snap${bin}.1"

			newconfd "${FILESDIR}/snap${bin}.confd" "snap${bin}"
			newinitd "${FILESDIR}/snap${bin}.initd" "snap${bin}"
		fi
	done
}
