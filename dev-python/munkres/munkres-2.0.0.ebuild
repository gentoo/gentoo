# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/iameishit/Paldita-munkres
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Module implementing munkres algorithm for the Assignment Problem"
HOMEPAGE="
	https://github.com/iameishit/Paldita-munkres/
	https://pypi.org/project/munkres/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# junk tests that require dotfiles from the git repo
	tests/integration/test_examples_and_benchmarks.py::test_release_verifier_reports_no_problems
	tests/test_repo_hygiene.py
)
