# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )
PYPI_NO_NORMALIZE=1
PYPI_PN="M2Crypto"
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="A Python crypto and SSL toolkit"
HOMEPAGE="
	https://gitlab.com/m2crypto/m2crypto/
	https://pypi.org/project/M2Crypto/
"

# openssl via src/SWIG/_lib11_compat.i
LICENSE="MIT openssl"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test abi_mips_n32 abi_mips_n64 abi_mips_o32"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-lang/swig-2.0.9
"
RDEPEND="
	dev-libs/openssl:=
"
DEPEND="${RDEPEND}"

distutils_enable_tests setup.py

swig_define() {
	local x
	for x; do
		if tc-cpp-is-true "defined(${x})"; then
			SWIG_FEATURES+=" -D${x}"
		fi
	done
}

src_prepare() {
	# relies on very exact clock behavior which apparently fails
	# with inconvenient CONFIG_HZ*
	sed -e 's:test_server_simple_timeouts:_&:' \
		-i tests/test_ssl.py || die
	distutils-r1_src_prepare
}

python_compile() {
	# setup.py looks at platform.machine() to determine swig options.
	# For exotic ABIs, we need to give swig a hint.
	local -x SWIG_FEATURES=

	# https://bugs.gentoo.org/617946
	swig_define __ILP32__

	# https://bugs.gentoo.org/674112
	swig_define __ARM_PCS_VFP

	# Avoid similar errors to bug #688668 for MIPS
	if use abi_mips_n32; then
	    swig_define _MIPS_SIM = _ABIN32
	elif use abi_mips_n64; then
	    swig_define _MIPS_SIM = _ABI64
	elif use abi_mips_o32; then
	    swig_define _MIPS_SIM = _ABIO32
	fi

	distutils-r1_python_compile --openssl="${ESYSROOT}"/usr
}
