# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Module to read and work with Portable Executable (PE) files"
HOMEPAGE="https://github.com/erocarrera/pefile"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/erocarrera/pefile.git"
	inherit git-r3
else
	SRC_URI="https://github.com/erocarrera/pefile/releases/download/v${PV}/${P}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"

# Unfortunately there is nothing we can test here. Upstream doesn't ship a test
# suite inside the release files. The test fixtures in the source repo is
# encrypted so that only their CI pipeline is able to run the tests.
