# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..12} )

CRATES=""

inherit cargo distutils-r1

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="https://virustotal.github.io/yara-x/"
SRC_URI="https://github.com/VirusTotal/yara-x/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${PN}-v${PV}-crates.tar.xz"

LICENSE="BSD"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 CDDL EPL-2.0 ISC MIT MPL-2.0 Unicode-DFS-2016 WTFPL-2
"

SLOT="0"
# Note: cranelift dependency only supports amd64, arm64, s390, and riscv64 as of 2025
KEYWORDS="amd64"
IUSE="python"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
	)
"

wrap_python() {
	local phase=$1
	shift

	if use python; then
		pushd py >/dev/null || die
		distutils-r1_${phase} "$@"
		popd >/dev/null || die
	fi
}

src_prepare() {
	default
	wrap_python ${FUNCNAME}
}

src_compile() {
	cargo_src_compile --workspace
	wrap_python ${FUNCNAME}
}

python_test() {
	epytest
}

src_test() {
	cargo_src_test
	wrap_python ${FUNCNAME}
}

src_install() {
	dobin "$(cargo_target_dir)"/yr
	dolib.so "$(cargo_target_dir)"/*.so

	wrap_python ${FUNCNAME}
}
