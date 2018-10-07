# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Synchronous multi-room audio player"
HOMEPAGE="https://github.com/badaix/snapcast"

if [[ ${PV} == *9999 ]] ; then
	inherit user cmake-utils git-r3

	EGIT_REPO_URI="https://github.com/badaix/snapcast.git"
	EGIT_BRANCH="develop"
else
	inherit user cmake-utils

	SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+avahi +client +flac +server static-libs test tremor +vorbis"

REQUIRED_USE="|| ( server client )"

RDEPEND="avahi? ( net-dns/avahi[dbus] )
	client? ( media-libs/alsa-lib )
	flac? ( media-libs/flac )
	tremor? ( media-libs/tremor )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	>=dev-cpp/aixlog-1.2.1
	>=dev-cpp/asio-1.12.1
	>=dev-cpp/popl-1.2.0"

PATCHES=( "${FILESDIR}/${PN}-options-for-use-flags.patch" )

pkg_preinst() {
	if use server ; then
		enewgroup "snapserver"
		enewuser "snapserver" -1 -1 /dev/null snapserver
	fi
	if use client ; then
		enewuser "snapclient" -1 -1 /dev/null audio
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_AVAHI=$(usex avahi)
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_WITH_FLAC=$(usex flac)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WITH_TREMOR=$(usex tremor)
		-DBUILD_WITH_VORBIS=$(usex vorbis)
	)

	cmake-utils_src_configure
}

src_install() {
	for bin in server client ; do
		if use ${bin} ; then
			doman "${bin}/snap${bin}.1"

			newconfd "${FILESDIR}/snap${bin}.confd" "snap${bin}"
			newinitd "${FILESDIR}/snap${bin}.initd" "snap${bin}"
		fi
	done

	cmake-utils_src_install
}
