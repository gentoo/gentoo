# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.com/yajl/"
SRC_URI="https://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"
S="${WORKDIR}/lloyd-yajl-66cb08c"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-uclibc.patch # git master 5d4bf525
	"${FILESDIR}"/${P}-pkg-config.patch # downstream
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
