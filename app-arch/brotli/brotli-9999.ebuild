# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL="1"
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit cmake-multilib distutils-r1

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Generic-purpose lossless compression algorithm"
HOMEPAGE="https://github.com/google/brotli"

LICENSE="MIT python? ( Apache-2.0 )"
SLOT="0/$(ver_cut 1)"
IUSE="python static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

DOCS=( README.md CONTRIBUTING.md )

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}
src_configure() {
	cmake-multilib_src_configure
	use python && distutils-r1_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}
src_compile() {
	cmake-multilib_src_compile
	use python && distutils-r1_src_compile
}

python_test() {
	esetup.py test || die
}

multilib_src_test() {
	cmake_src_test
}
src_test() {
	cmake-multilib_src_test
	use python && distutils-r1_src_test
}

multilib_src_install() {
	cmake_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a || die
}
multilib_src_install_all() {
	use python && distutils-r1_src_install
}
