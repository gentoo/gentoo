# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake-multilib python-r1

DESCRIPTION="A tool to test PAM applications and PAM modules"
HOMEPAGE="https://cwrap.org/pam_wrapper.html"
SRC_URI="
	https://www.samba.org/ftp/pub/cwrap/${P}.tar.gz
	https://ftp.samba.org/pub/cwrap/${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Require newer PAM so we know where it's located, bug #825078
RDEPEND="
	${PYTHON_DEPS}
	>=sys-libs/pam-1.5.3-r1:0=[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.4-tests-import.patch
)

multilib_src_configure() {
	configure_for_python() {
		local mycmakeargs=( -DUNIT_TESTING=OFF )
		cmake_src_configure
	}

	if multilib_is_native_abi ; then
		# Build the Pythons for each version (but only for the native ABI)
		# bug #737468
		python_foreach_impl configure_for_python
	fi

	# Do the regular build now
	local mycmakeargs=(
		-DUNIT_TESTING=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_Python{Libs,Interp,SiteLibs}=ON
	)
	cmake_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		python_foreach_impl cmake_src_compile
	fi

	# Compile the "proper" version without Python last
	cmake_src_compile
}

multilib_src_test() {
	cmake_src_test

	# Fails b/c of sandbox?
	#python_test() {
	#	local -x PYTHONPATH="${BUILD_DIR}/src/python/python3:${PYTHONPATH}"
	#	elog "${PYTHONPATH}"
	#	${EPYTHON} "${S}"/tests/pypamtest_test.py || die "Tests failed with ${EPYTHON}"
	#}

	#if multilib_is_native_abi ; then
	#	python_foreach_impl python_test
	#fi
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		python_foreach_impl cmake_src_install
	fi

	# Install the "proper" version without Python last
	cmake_src_install
}
