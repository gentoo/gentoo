# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Dependency injection framework for Qt5"
HOMEPAGE="https://github.com/vogel/injeqt"
SRC_URI="https://github.com/vogel/injeqt/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-qt/qtcore-5.4.2:5
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-5.4.2:5 )
"

PATCHES=(
	"${FILESDIR}/${PN}-cmake-preserve-cxxflags.patch"
)

src_configure() {
	local mycmakeargs=(
		-DDISABLE_EXAMPLES=ON
		$(cmake-utils_use_disable test TESTS)
	)
	cmake-utils_src_configure
}
