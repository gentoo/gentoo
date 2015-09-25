# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_MIN_VERSION="3.0"
CMAKE_BUILD_TYPE="Release"

# This ebuild could use some python checks, as sigil contains python plugin architecture.

inherit eutils cmake-utils

MY_PN="Sigil"

DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor for ePub format"
HOMEPAGE="http://sigil-ebook.com/"
SRC_URI="https://github.com/Sigil-Ebook/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-text/hunspell-1.3.2
	>=dev-libs/boost-1.49[threads]
	>=dev-libs/libpcre-8.31[pcre16]
	>=dev-libs/xerces-c-3.1.1[icu]
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
	>=sys-libs/zlib-1.2.7[minizip]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-qt/linguist-tools-5.4:5
"

S="${WORKDIR}/${MY_PN}-${PV}"

DOCS=( README.md )

src_prepare() {
	# sigil tries to copy non-needed qt libs for deb package, safe to ignore this completely
	sed -e '/set( QT_LIBS/d' -i src/Sigil/CMakeLists.txt || die "sed failed"

	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure

	cd "${WORKDIR}/${P}_build" || die "Where is the build dir?"
	for i in CMakeCache.txt src/Sigil/CMakeFiles/sigil.dir/link.txt $(find . -name '*.make')
	do
		sed -e 's/-O3 -DNDEBUG/-DNDEBUG/' -i ${i} || die "sed failed"
	done
}
