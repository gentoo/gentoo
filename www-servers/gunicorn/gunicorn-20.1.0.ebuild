# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="A WSGI HTTP Server for UNIX"
HOMEPAGE="https://gunicorn.org https://pypi.org/project/gunicorn https://github.com/benoitc/gunicorn"
# Tagged on GitHub on 2021-02-12 yet only got posted on PyPI on 2021-03-27, two weeks
# before this ebuild got published. Will likely switch back to PyPI come next release.
SRC_URI="https://github.com/benoitc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT PSF-2 doc? ( BSD )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]"

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
