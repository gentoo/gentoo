# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Synchronize calendars and contacts"
HOMEPAGE="https://github.com/pimutils/vdirsyncer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-0.16.8-click-7-compat.patch" )

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.3.0[${PYTHON_USEDEP}]
	<dev-python/click-log-0.4.0[${PYTHON_USEDEP}]
	dev-python/click-threading[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/atomicwrites[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pytest-subtesthack[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst README.rst config.example )

distutils_enable_tests pytest

src_prepare() {
	default

	# Replace getiterator with iter for python3.9.
	# See https://github.com/pimutils/vdirsyncer/issues/880.
	sed -i "s/rv.extend(item.getiterator())/rv.extend(iter(item))/" \
		vdirsyncer/storage/dav.py || die
}

python_test() {
	# skip tests needing servers running
	local -x DAV_SERVER=skip
	local -x REMOTESTORAGE_SERVER=skip
	# pytest dies hard if the envvars do not have any value...
	local -x CI=false
	local -x DETERMINISTIC_TESTS=false
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
