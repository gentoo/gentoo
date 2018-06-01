# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="http://wiki.gpodder.org/wiki/Libmygpo-qt"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gpodder/libmygpo-qt.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gpodder/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-qt/qttest:5 )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT4=OFF
		-DMYGPO_BUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}
