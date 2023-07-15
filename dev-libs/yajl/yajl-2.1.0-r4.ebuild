# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib multibuild

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.io/yajl/"
SRC_URI="https://github.com/lloyd/yajl/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/lloyd-yajl-66cb08c"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-uclibc.patch # git master 5d4bf525
	"${FILESDIR}"/${P}-pkg-config.patch # downstream
	"${FILESDIR}"/${P}-memory-leak.patch # Bug 908036
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
