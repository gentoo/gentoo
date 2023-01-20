# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="HCL configuration parser for python"
HOMEPAGE="https://github.com/virtuald/pyhcl"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/virtuald/pyhcl.git"
else
	SRC_URI="https://github.com/virtuald/pyhcl/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MPL-2.0"
SLOT="0"

distutils_enable_tests pytest

python_prepare_all() {
	printf '__version__ = "%s"\n' "${PV}" > src/hcl/version.py || die
	distutils-r1_python_prepare_all
}
