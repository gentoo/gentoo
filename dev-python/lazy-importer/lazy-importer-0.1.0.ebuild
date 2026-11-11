# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYPI_VERIFY_REPO=https://github.com/pganssle/lazy_importer
# backport/shim from 3.15, ideally not used on 3.15
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A context manager for portable, opt-in lazy imports"
HOMEPAGE="
	https://github.com/pganssle/lazy_importer/
	https://pypi.org/project/lazy-importer/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
