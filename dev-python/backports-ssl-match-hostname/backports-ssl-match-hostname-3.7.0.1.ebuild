# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )
inherit pypi distutils-r1

MY_PN=${PN/-/.}
MY_PN=${MY_PN//-/_}
DESCRIPTION="The ssl.match_hostname() function from Python 3.7"
HOMEPAGE="
	https://pypi.org/project/backports.ssl_match_hostname/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}" "${PV}")"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

python_prepare_all() {
	sed -e 's:from distutils.core:from setuptools:' -i setup.py || die
	distutils-r1_python_prepare_all
}
