# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OSPG/binwalk.git"
	inherit git-r3
else
	SRC_URI="https://github.com/OSPG/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86 ~x64-macos"
fi

DESCRIPTION="A tool for identifying files embedded inside firmware images"
HOMEPAGE="https://github.com/ReFirmLabs/binwalk"

LICENSE="MIT"
SLOT="0"

distutils_enable_tests pytest

python_install_all() {
	local DOCS=( API.md INSTALL.md README.md )
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "binwalk has many optional dependencies to automatically"
		elog "extract/decompress data, see INSTALL.md for more details."
	fi
}
