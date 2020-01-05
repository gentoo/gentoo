# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A convenient function to download to a file using requests"
HOMEPAGE="https://github.com/takluyver/requests_download https://pypi.org/project/requests_download/"
SRC_URI="https://github.com/takluyver/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

# there are no tests upstream
RESTRICT="test"

DOCS=( README.rst )

python_prepare_all() {
	printf -- "from setuptools import setup\nsetup(name='%s',version='%s',py_modules=['%s'])" \
		"${PN}" "${PV}" "${PN}" > setup.py || die

	distutils-r1_python_prepare_all
}
