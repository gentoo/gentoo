# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

case ${PV} in
*9999*)
	EGIT_REPO_URI="https://github.com/sigrokproject/${PN}.git"
	inherit git-r3
	;;
*_p*)
	COMMIT="e2fe9dfb91c7de85c410922ee9268c3f526bcc54"
	SRC_URI="https://github.com/sigrokproject/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT:0:7}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	;;
*)
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	;;
esac

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="https://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi
IUSE="+decode static"

RDEPEND="
	>=dev-cpp/glibmm-2.68.0:2.68
	dev-libs/boost:=
	>=dev-libs/glib-2.28.0:2
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtsvg:6
	>=sci-libs/libsigrok-0.6.0:=[cxx]
	decode? ( >=sci-libs/libsigrokdecode-0.6.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

DOCS=( HACKING NEWS README )

PATCHES=( "${FILESDIR}/${PN}-0.5.0-glibmm-2.68-required.patch" )

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory manual
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
		-DENABLE_DECODE=$(usex decode)
		-DSTATIC_PKGDEPS_LIBS=$(usex static)
	)
	cmake_src_configure
}
