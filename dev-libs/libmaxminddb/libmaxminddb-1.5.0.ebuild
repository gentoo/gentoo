# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

TEST_COMMIT="39431da7fb6834c0cbe0c70a81074e65299dece7"
DESCRIPTION="C library for the MaxMind DB file format"
HOMEPAGE="https://github.com/maxmind/libmaxminddb"
SRC_URI="https://github.com/maxmind/libmaxminddb/releases/download/${PV}/${P}.tar.gz"
SRC_URI+=" test? ( https://github.com/maxmind/MaxMind-DB/archive/${TEST_COMMIT}.tar.gz -> ${P}-test-data.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0/0.0.7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
# Out of date test data shipped
RESTRICT="test"

DOCS=( Changes.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
