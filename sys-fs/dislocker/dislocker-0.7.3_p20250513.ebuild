# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="4572dc727940cc42249c9f967cee9c505f16b121"
CMAKE_REMOVE_MODULES_LIST=( ${CMAKE_REMOVE_MODULES_LIST} FindRuby )
inherit cmake

DESCRIPTION="Dislocker is used to read BitLocker encrypted partitions"
HOMEPAGE="https://github.com/Aorimn/dislocker"
SRC_URI="https://github.com/Aorimn/dislocker/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ruby"

DEPEND="
	sys-fs/fuse:0=
	net-libs/mbedtls:3=
	ruby? ( dev-lang/ruby:* )
"
RDEPEND="${DEPEND}"

PATCHES=(
	# downstream patches
	"${FILESDIR}/${PN}-0.7.3_p20250513-no-git.patch"
	"${FILESDIR}/${PN}-0.7.3_p20250513-cmake.patch"
	"${FILESDIR}/${PN}-0.7.3_p20250513-cmake4.patch" # bug 957277
	# Pending upstream:
	"${FILESDIR}/${PN}-0.7.3_p20250513_mbedtls-3.patch"
)

src_prepare() {
	# Part of dislocker-0.7.3_p20250513_mbedtls-3.patch
	mv include/dislocker/ssl_bindings.h{.in,} || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ruby Ruby)
	)

	cmake_src_configure
}

src_install() {
	if ! use ruby; then
		rm "${S}/man/linux/${PN}-find.1" || die
	fi

	find "${S}/man/linux" -name '*.1' -exec doman '{}' + || die
	cmake_src_install
}
