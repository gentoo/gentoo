# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# This value is obtained by running the following on the checked out
# tag:
# git describe --tags --long
LONG_VERSION=0.4.4-0-g314cd32
PYTHON_COMPAT=( python3_8 python3_9 )
inherit distutils-r1

DESCRIPTION="HCL configuration parser for python"
HOMEPAGE="https://github.com/virtuald/pyhcl"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/virtuald/pyhcl.git"
else
	SRC_URI="https://github.com/virtuald/pyhcl/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MPL-2.0"
SLOT="0"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	printf '__version__ = "%s"\n' "${LONG_VERSION}" > src/hcl/version.py || die
}
