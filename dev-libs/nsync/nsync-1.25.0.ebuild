# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C library that exports various synchronization primitives, such as mutexes"
HOMEPAGE="https://github.com/google/nsync"
SRC_URI="https://github.com/google/nsync/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DNSYNC_ENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}
