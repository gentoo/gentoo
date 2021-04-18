# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Compresses linked and inline JavaScript or CSS into single cached files."
HOMEPAGE="https://django-compressor.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${P/-/_}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# missing test deps, package does not handle them gracefully, also seem
# broken or whatever
RESTRICT="test"

RDEPEND="dev-python/django-appconf[${PYTHON_USEDEP}]
	dev-python/rcssmin[${PYTHON_USEDEP}]
	dev-python/rjsmin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	django-admin.py test --settings=compressor.test_settings compressor ||
		die "Tests failed with ${EPYTHON}"
}
