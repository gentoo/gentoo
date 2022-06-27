# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="
	https://gunicorn.org/
	https://github.com/benoitc/gunicorn/
	https://pypi.org/project/gunicorn/
"
SRC_URI="
	https://github.com/benoitc/gunicorn/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT PSF-2 doc? ( BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-20.1.0-tests_optional_modules.patch
	"${FILESDIR}"/${P}-new-eventlet.patch
)

DOCS=( README.rst )

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

pkg_postinst() {
	optfeature_header "Alternative worker types need additional packages to be installed:"
	optfeature "eventlet-based greenlets workers" "dev-python/eventlet"
	optfeature "gevent-based greenlets workers" "dev-python/gevent"
}
