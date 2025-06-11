# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Pytest plugin to support for a predictable and repeatable temporary directory"
HOMEPAGE="
	https://github.com/vmware-archive/pytest-tempdir/
	https://pypi.org/project/pytest-tempdir/
"
SRC_URI="
	https://github.com/vmware-archive/pytest-tempdir/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

distutils_enable_tests pytest
