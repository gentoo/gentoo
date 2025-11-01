# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C/C++ WebRTC network lib: Data Channels / Media Transport / WebSockets"
HOMEPAGE="https://github.com/paullouisageneau/libdatachannel"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/paullouisageneau/libdatachannel.git"
else
	SRC_URI="https://github.com/paullouisageneau/libdatachannel/archive/refs/tags/v$PV.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="+gnutls"

DEPEND="
	dev-cpp/nlohmann_json
	dev-libs/glib:2
	dev-libs/plog
	net-libs/libnice[!gnutls?]
	net-libs/libsrtp:2=
	net-libs/usrsctp
	gnutls? (
		net-libs/gnutls:=
		dev-libs/nettle:=
	)
	!gnutls? (
		dev-libs/openssl:=
	)
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_GNUTLS=$(usex gnutls ON OFF)
		-DPREFER_SYSTEM_LIB=ON
		-DUSE_NICE=ON
	)

	cmake_src_configure
}
