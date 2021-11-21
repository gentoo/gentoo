# Copyright 2008-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS="bdepend"

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/30"
KEYWORDS=""
IUSE=""

BDEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
	dev-python/namespace-google[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}"
RDEPEND="${BDEPEND}"

S="${WORKDIR}/protobuf-${PV}/python"

if [[ "${PV}" == "9999" ]]; then
	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
fi

python_prepare_all() {
	pushd "${WORKDIR}/protobuf-${PV}" > /dev/null || die
	eapply "${FILESDIR}/${PN}-3.13.0-google.protobuf.pyext._message.PyUnknownFieldRef.patch"
	eapply_user
	popd > /dev/null || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(--cpp_implementation)
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	find "${ED}" -name "*.pth" -type f -delete || die
}
