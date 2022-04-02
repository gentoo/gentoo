# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_P=${P/quarter/Quarter}

HOMEPAGE="https://github.com/coin3d/coin/wiki"
DESCRIPTION="GUI binding for using Coin/Open Inventor with Qt"
SRC_URI="https://github.com/coin3d/quarter/releases/download/${MY_P}/${P}-src.tar.gz"
S="${WORKDIR}/quarter"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug designer doc man qthelp"

REQUIRED_USE="
	man? ( doc )
	qthelp? ( doc )
"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/coin
	virtual/opengl
	designer? ( dev-qt/designer:5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		qthelp? ( dev-qt/qthelp:5 )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-cmake.patch
	"${FILESDIR}"/${PN}-1.1.0-find-qhelpgenerator-binary.patch
)

DOCS=(AUTHORS ChangeLog NEWS README)

src_prepare() {
	cmake_src_prepare
	sed -e 's|/lib$|/lib@LIB_SUFFIX@|' \
		-i Quarter.pc.cmake.in || die
}

src_configure() {
	use debug && append-cppflags -DQUARTER_DEBUG=1
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DQUARTER_BUILD_SHARED_LIBS=ON
		-DQUARTER_BUILD_PLUGIN=$(usex designer)
		-DQUARTER_BUILD_EXAMPLES=OFF
		-DQUARTER_BUILD_DOCUMENTATION=$(usex doc)
		-DQUARTER_BUILD_INTERNAL_DOCUMENTATION=OFF
		-DQUARTER_BUILD_DOC_MAN=$(usex man)
		-DQUARTER_BUILD_DOC_QTHELP=$(usex qthelp)
		-DQUARTER_BUILD_DOC_CHM=OFF
		-DQUARTER_USE_QT5=ON
	)
	cmake_src_configure
}
