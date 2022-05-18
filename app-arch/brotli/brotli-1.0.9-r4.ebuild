# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL="1"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit cmake-multilib distutils-r1

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	SRC_URI="
		https://github.com/google/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz
		test? (
			https://dev.gentoo.org/~mgorny/dist/${P}.testdata.tar.xz
		)
	"
fi

DESCRIPTION="Generic-purpose lossless compression algorithm"
HOMEPAGE="https://github.com/google/brotli/"

LICENSE="MIT python? ( Apache-2.0 )"
SLOT="0/$(ver_cut 1)"
IUSE="python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md CONTRIBUTING.md )

PATCHES=( "${FILESDIR}/${PV}-linker.patch" )

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

src_compile() {
	cmake-multilib_src_compile
	use python && distutils-r1_src_compile
}

python_test() {
	eunittest -s python -p "*_test.py"
}

src_test() {
	cmake-multilib_src_test
	use python && distutils-r1_src_test
}

multilib_src_install() {
	cmake_src_install
	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}

multilib_src_install_all() {
	use python && distutils-r1_src_install
}
