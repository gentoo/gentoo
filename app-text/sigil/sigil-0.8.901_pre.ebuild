# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_MIN_VERSION="3.0"

# Sigil supports Python 3.5 already. Include it when we have the deps for it.
PYTHON_COMPAT=( python3_4 )

inherit eutils cmake-utils python-single-r1

MY_PN="Sigil"
MY_PV="0.8.901"

DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor for ePub format"
HOMEPAGE="http://sigil-ebook.com/"
SRC_URI="https://github.com/Sigil-Ebook/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost[threads]
	dev-libs/libpcre[pcre16]
	dev-libs/xerces-c[icu]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/cssutils[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-qt/qtconcurrent-5.4:5
	>=dev-qt/qtcore-5.4:5
	>=dev-qt/qtgui-5.4:5
	>=dev-qt/qtnetwork-5.4:5
	>=dev-qt/qtprintsupport-5.4:5
	>=dev-qt/qtsvg-5.4:5
	>=dev-qt/qtwebkit-5.4:5
	>=dev-qt/qtwidgets-5.4:5
	>=dev-qt/qtxml-5.4:5
	>=dev-qt/qtxmlpatterns-5.4:5
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=sys-devel/gcc-4.8
	virtual/pkgconfig
	>=dev-qt/linguist-tools-5.4:5
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

DOCS=( ChangeLog.txt README.md )

src_prepare() {
	# sigil tries to copy non-needed qt libs for deb package, safe to ignore this completely
	sed -e '/set( QT_LIBS/d' -i src/CMakeLists.txt || die "sed failed"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_LIBS=1
		-DSYSTEM_LIBS_REQUIRED=1
	)
	cmake-utils_src_configure
}
