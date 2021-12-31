# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
fi

DESCRIPTION="A PulseAudio NCurses mixer"
HOMEPAGE="https://github.com/patroclos/PAmix"
LICENSE="MIT"
SLOT="0"
IUSE="+unicode"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/patroclos/PAmix.git"
else
	SRC_URI="https://github.com/patroclos/PAmix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/PAmix-${PV}"
fi

RDEPEND="media-sound/pulseaudio
	sys-libs/ncurses:0=[unicode?]"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DWITH_UNICODE="$(usex unicode)"
	)
	cmake_src_configure
}
