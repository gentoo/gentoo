# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://github.com/protocolbuffers/protobuf/
	https://pypi.org/project/protobuf/
"
if [[ "${PV}" != "9999" ]]; then
	SRC_URI="
		https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz
			-> protobuf-${PV}.tar.gz
	"
fi
S="${WORKDIR}/protobuf-${PV}/python"

LICENSE="BSD"
SLOT="0/30"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
"
RDEPEND="
	${BDEPEND}
	!dev-python/namespace-google
"

if [[ "${PV}" == "9999" ]]; then
	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
fi

distutils_enable_tests setup.py

python_prepare_all() {
	pushd "${WORKDIR}/protobuf-${PV}" > /dev/null || die
	eapply "${FILESDIR}/${PN}-3.19.0-google.protobuf.pyext._message.PyUnknownFieldRef.patch"
	eapply_user
	popd > /dev/null || die

	distutils-r1_python_prepare_all
}

src_configure() {
	DISTUTILS_ARGS=(--cpp_implementation)
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}/install" -name "*.pth" -type f -delete || die
}
