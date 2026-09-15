# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GUI binding for using Coin/Open Inventor with Xt/Motif"
HOMEPAGE="https://github.com/coin3d/soxt https://github.com/coin3d/coin/wiki"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin3d/${PN,,}.git"
else
	SRC_URI="https://github.com/coin3d/${PN,,}/releases/download/v${PV}/${P/${PN}/${PN,,}}-src.tar.gz"
	S="${WORKDIR}/${PN,,}"

	KEYWORDS="amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/coin
	x11-libs/motif:0=
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	virtual/opengl[X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-text/doxygen )
"

DOCS=(
	AUTHORS
	ChangeLog
	HACKING
	NEWS
	README
	TODO
	BUGS.txt
)

src_prepare() {
	cmake_src_prepare

	if has_version ">=x11-libs/motif-2.3.9"; then
		eapply "${FILESDIR}/${PN}-1.4.2-motif-2.3.9-version.h.patch"
	fi
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"

	local mycmakeargs=(
		-D${PN^^}_BUILD_SHARED_LIBS="yes"

		-D${PN^^}_BUILD_AWESOME_DOCUMENTATION="$(usex doc)"
		-D${PN^^}_BUILD_DOCUMENTATION="$(usex doc)"
		-D${PN^^}_BUILD_DOC_MAN="$(usex doc)"
		-D${PN^^}_BUILD_INTERNAL_DOCUMENTATION="no"

		# Interactive test programs
		-D${PN^^}_BUILD_TESTS="$(usex test)"
		-D${PN^^}_VERBOSE="$(usex debug)"
	)

	cmake_src_configure
}
