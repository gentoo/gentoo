# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

MY_P=${P/quarter/Quarter}

HOMEPAGE="https://github.com/coin3d/coin/wiki"
DESCRIPTION="GUI binding for using Coin/Open Inventor with Qt"
SRC_URI="https://github.com/coin3d/quarter/releases/download/${MY_P}/${P}-src.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="debug designer doc man qthelp"

REQUIRED_USE="
	man? ( doc )
	qthelp? ( doc )
"

RDEPEND="
	media-libs/coin
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtopengl:5
	virtual/opengl
	designer? ( dev-qt/designer:5 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		qthelp? ( dev-qt/qthelp:5 )
	)
"

S="${WORKDIR}/quarter"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-cmake.patch
)

DOCS=(AUTHORS ChangeLog NEWS README)

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
