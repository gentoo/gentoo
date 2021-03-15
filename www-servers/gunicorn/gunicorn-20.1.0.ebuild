# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1 optfeature

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="https://gunicorn.org https://pypi.org/project/gunicorn https://github.com/benoitc/gunicorn"
# Not on PyPI yet as of 2021-03-15
SRC_URI="https://github.com/benoitc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT PSF-2 doc? ( BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"

RDEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]"

DOCS=( README.rst )

distutils_enable_sphinx 'docs/source' --no-autodoc
distutils_enable_tests pytest

src_prepare() {
	# These fail if respective optional packages have not been installed
	rm -f tests/workers/test_g{eventlet,gevent}.py

	sed -e 's:--cov=gunicorn --cov-report=xml::' -i setup.cfg || die

	distutils-r1_src_prepare
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/source/_build/html/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Note that alternative worker types need additional packages to be installed:"
	optfeature "eventlet-based greenlets workers" "dev-python/eventlet"
	optfeature "gevent-based greenlets workers" "dev-python/gevent"
	elog
}
