# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib multibuild

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.io/yajl/"
SRC_URI="https://github.com/lloyd/yajl/archive/refs/tags/${PV}.tar.gz -> ${P}-r5.tar.gz"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-uclibc.patch # git master 5d4bf525
	"${FILESDIR}"/${P}-pkg-config.patch # downstream
	"${FILESDIR}"/${P}-memory-leak.patch # Bug 908036
	"${FILESDIR}"/${PN}-2.1.0-cmake-4.patch # Bug 951675
)

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_test() {
	cd "${S}"/test/parsing || die
	./run_tests.sh "${BUILD_DIR}"/test/parsing/yajl_test || die
}

src_install() {
	cmake-multilib_src_install
	find "${D}" -name libyajl_s.a -delete || die
}
