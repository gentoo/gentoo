# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/patroclos/PAmix.git"
	inherit git-r3
else
	SRC_URI="https://github.com/patroclos/PAmix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/PAmix-${PV}"
fi

DESCRIPTION="A PulseAudio NCurses mixer"
HOMEPAGE="https://github.com/patroclos/PAmix"

LICENSE="MIT"
SLOT="0"
IUSE="+unicode"

RDEPEND="
	media-sound/pulseaudio
	sys-libs/ncurses:0=[unicode?]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-ncurses_pkgconfig.patch"
	"${FILESDIR}/${P}-xdgconfigdir.patch"
	"${FILESDIR}/${P}-fix-output-scrolling.patch"
	"${FILESDIR}/${P}-fix-ncurses-freezing.patch"
)

src_prepare() {
	cmake_src_prepare
	if [[ ${PV} != 9999 ]] ; then
		sed -e "/^include(CMakeGitDefines.cmake)/d" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_UNICODE="$(usex unicode)"
	)
	[[ ${PV} != 9999 ]] && mycmakeargs+=( -DGIT_VERSION=${PV} )
	cmake_src_configure
}
