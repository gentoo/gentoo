# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 flag-o-matic multiprocessing prefix pypi

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/re2-0.2021.11.01:=
	<dev-python/protobuf-python-5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-4.21.3[${PYTHON_USEDEP}]
	net-dns/c-ares:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/1.51.0-respect-cc.patch"
	"${FILESDIR}/1.51.0-cython3.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

python_configure_all() {
	# -Werror=odr -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/856775
	# https://github.com/grpc/grpc/issues/36158
	filter-lto

	# os.environ.get('GRPC_BUILD_WITH_BORING_SSL_ASM', True)
	export GRPC_BUILD_WITH_BORING_SSL_ASM=
	export GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_WITH_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}
