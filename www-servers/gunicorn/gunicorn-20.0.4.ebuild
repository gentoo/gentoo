# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="https://gunicorn.org https://pypi.org/project/gunicorn https://github.com/benoitc/gunicorn"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT PSF-2 doc? ( BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~sparc x86"

RDEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]"

DOCS="README.rst"

distutils_enable_sphinx 'docs/source' --no-autodoc
distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--cov=gunicorn --cov-report=xml::' -i setup.cfg || die
	distutils-r1_src_prepare
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/source/_build/html/. )

	distutils-r1_python_install_all
}
