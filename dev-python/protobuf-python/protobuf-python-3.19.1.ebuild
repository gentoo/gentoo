# Copyright 2008-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
	EGIT_SUBMODULES=()
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"
fi
S="${WORKDIR}/protobuf-${PV}/python"

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"

LICENSE="BSD"
SLOT="0/30"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
	dev-python/namespace-google[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}"
RDEPEND="${BDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.19.1-google.protobuf.pyext._message.PyUnknownFieldRef.patch"
)

distutils_enable_tests setup.py

python_configure_all() {
	mydistutilsargs=(
		--cpp_implementation
	)
}

python_install_all() {
	distutils-r1_python_install_all

	find "${ED}" -name "*.pth" -type f -delete || die
}
