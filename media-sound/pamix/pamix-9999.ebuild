# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SCM=""
[[ "${PV}" == 9999 ]] && SCM="git-r3"
inherit cmake-utils ${SCM}
unset SCM

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
DEPEND="sys-devel/autoconf-archive
	virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	default

	# ugly hackaround for split tinfo ncurses libs
	sed '/link_libraries.*ncurses/s@\(")\)@" "tinfo\1@' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_UNICODE="$(usex unicode)"
	)
	cmake-utils_src_configure
}
