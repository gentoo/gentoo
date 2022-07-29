# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Parser like ConfigParser but for updating configuration files"
HOMEPAGE="
	https://github.com/pyscaffold/configupdater/
	https://pypi.org/project/ConfigUpdater/
"
SRC_URI="
	https://github.com/pyscaffold/configupdater/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT PSF-2 PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' setup.cfg || die
}
