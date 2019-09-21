# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/ https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/7"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="test"

multilib_src_configure() {
	local mycmakeargs=( -DBUILD_TESTING=$(usex test) )
	cmake-utils_src_configure
}
