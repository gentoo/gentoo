# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 multiprocessing pypi

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="
	https://github.com/grpc/grpc/
	https://grpc.io
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+system-cares +system-re +system-ssl +system-zlib"

DEPEND="system-cares? ( net-dns/c-ares )
	system-re? ( dev-libs/re2 )
	system-ssl? ( dev-libs/openssl )
	system-zlib? ( sys-libs/zlib )
"
RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

src_prepare() {
	if use x86 && ! use system-ssl ; then
		# Adds OPENSSL_NO_ASM macro via check
		eapply "${FILESDIR}/${PN}-build-x86.patch"
	fi
	eapply_user
}

python_configure_all() {
	if use system-cares ; then
		export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	fi
	if use system-re ;  then
		export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
	fi
	if use system-ssl ; then
		export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	fi
	if use system-zlib ; then
		export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	fi
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}
