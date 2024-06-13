# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

PARENT_PN="${PN/-python/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PARENT_P}"
else
	SRC_URI="
		https://github.com/protocolbuffers/protobuf/archive/v${PARENT_PV}.tar.gz
			-> ${PARENT_P}.tar.gz
	"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~mips ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://pypi.org/project/protobuf/
"

LICENSE="BSD"
SLOT="0/22.5.0"

S="${WORKDIR}/${PARENT_P}/python"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	dev-libs/protobuf:${SLOT}
"

distutils_enable_tests setup.py

# Same than PATCHES but from repository's root directory,
# please see function `python_prepare_all` below.
# Simplier for users IMHO.
PARENT_PATCHES=(
	"${FILESDIR}/${P}-c++-17.patch"
)

# Here for patches within "python/" subdirectory.
PATCHES=(
	"${FILESDIR}/${PN}-4.22.5-python.patch"
)

python_prepare_all() {
	pushd "${WORKDIR}/${PARENT_P}" > /dev/null || die
	[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
	eapply_user
	popd > /dev/null || die

	distutils-r1_python_prepare_all
}

src_configure() {
	DISTUTILS_ARGS=( --cpp_implementation )
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}/install" -name "*.pth" -type f -delete || die
}

python_install() {
	distutils-r1_python_install

	einfo "Installing headers"
	insinto /usr/include/google/protobuf
	doins google/protobuf/proto_api.h
}
