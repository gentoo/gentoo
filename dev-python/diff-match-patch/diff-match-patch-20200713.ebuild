# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Diff, match and patch algorithms for plain text"
HOMEPAGE="https://pypi.org/project/diff-match-patch/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest
