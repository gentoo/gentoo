# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{13..14} )

inherit distutils-r1 pypi

DESCRIPTION="An LTS port of Python's audioop module"
HOMEPAGE="
	https://github.com/AbstractUmbra/audioop
	https://pypi.org/project/audioop-lts/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests pytest

python_test() {
	rm -rf audioop || die
	epytest
}
