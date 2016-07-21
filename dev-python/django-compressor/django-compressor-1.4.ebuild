# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

MY_PN="${PN/-/_}"

DESCRIPTION="Compresses linked and inline javascript or CSS into a single cached file"
HOMEPAGE="https://github.com/django-compressor/django-compressor"
SRC_URI="https://github.com/jezdez/django_compressor/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE="doc test"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/django-appconf-0.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/versiontools[${PYTHON_USEDEP}]
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/django-discover-runner[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/Coffin[${PYTHON_USEDEP}]
		dev-python/jingo[${PYTHON_USEDEP}]
	)"
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# https://github.com/django-compressor/django-compressor/issues/531 532
	pushd "${BUILD_DIR}/lib" > /dev/null || die
	if python_is_python3; then
		sed -e s':test_cachekey:_&:' -e s':test_css:_&:g' \
			 -i compressor/tests/test_base.py || die
	fi
	set -- django-admin.py test compressor --settings=compressor.test_settings
	echo "$@"
	"$@" || die "Tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
