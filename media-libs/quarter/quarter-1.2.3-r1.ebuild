# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GUI binding for using Coin/Open Inventor with Qt"
HOMEPAGE="https://github.com/coin3d/quarter https://github.com/coin3d/coin/wiki"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin3d/${PN,,}.git"
else
	SRC_URI="https://github.com/coin3d/${PN,,}/releases/download/v${PV}/${P/${PN}/${PN,,}}-src.tar.gz"
	S="${WORKDIR}/${PN,,}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug designer doc qch"

REQUIRED_USE="qch? ( doc )"
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	dev-qt/qttools:6[widgets,designer?]
	media-libs/coin
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		qch? ( dev-qt/qttools:6[assistant] )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.1-cmake.patch"
	"${FILESDIR}/${PN}-1.2.2-find-qhelpgenerator.patch" # bug 933432
)

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	cmake_src_prepare

	sed -e 's|/lib$|/lib@LIB_SUFFIX@|' \
		-i Quarter.pc.cmake.in || die
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"

	local mycmakeargs=(
		-D${PN^^}_BUILD_SHARED_LIBS=ON

		-D${PN^^}_BUILD_PLUGIN=$(usex designer)
		-D${PN^^}_BUILD_EXAMPLES=OFF

		-D${PN^^}_BUILD_AWESOME_DOCUMENTATION=$(usex doc)
		-D${PN^^}_BUILD_DOCUMENTATION=$(usex doc)
		-D${PN^^}_BUILD_DOC_MAN=$(usex doc)
		-D${PN^^}_BUILD_DOC_QTHELP=$(usex qch)
		-D${PN^^}_BUILD_DOC_CHM=OFF
		-D${PN^^}_BUILD_INTERNAL_DOCUMENTATION=OFF

		-D${PN^^}_USE_QT5="no"
		-D${PN^^}_USE_QT6="yes"
	)

	use doc && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON )

	cmake_src_configure
}
