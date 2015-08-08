# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="http://wiki.gpodder.org/wiki/Libmygpo-qt"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gpodder/libmygpo-qt.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-2
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/gpodder/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="dev-qt/qtcore:4
	>=dev-libs/qjson-0.5"
DEPEND="${RDEPEND}
	dev-qt/qttest:4
	virtual/pkgconfig
	test? ( dev-qt/qttest:4 )"

DOCS=( AUTHORS README )

src_prepare() {
	cmake-utils_src_prepare
	if ! use test ; then
		sed -i -e '/find_package/s/QtTest//' CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use test MYGPO_BUILD_TESTS)
	)
	cmake-utils_src_configure
}
