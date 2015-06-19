# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/flexget/flexget-1.2.141.ebuild,v 1.3 2015/04/08 18:04:50 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

if [[ ${PV} != 9999 ]]; then
	MY_P="FlexGet-${PV}"
	SRC_URI="http://download.flexget.com/${MY_P}.tar.gz
		http://download.flexget.com/archive/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="git://github.com/Flexget/Flexget.git
		https://github.com/Flexget/Flexget.git"
fi

DESCRIPTION="Multipurpose automation tool for content like torrents, nzbs, podcasts, comics"
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
IUSE="test transmission"

DEPEND="
	>=dev-python/feedparser-5.1.3[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.5[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-0.9.99
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.1:4[${PYTHON_USEDEP}]
	<dev-python/beautifulsoup-4.4:4[${PYTHON_USEDEP}]
	!=dev-python/beautifulsoup-4.2.0
	>=dev-python/html5lib-0.11[${PYTHON_USEDEP}]
	dev-python/PyRSS2Gen[${PYTHON_USEDEP}]
	dev-python/pynzb[${PYTHON_USEDEP}]
	dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/rpyc[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0[${PYTHON_USEDEP}]
	<dev-python/requests-2.99[${PYTHON_USEDEP}]
	=dev-python/python-dateutil-2.1*[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
	dev-python/python-tvrage[${PYTHON_USEDEP}]
	dev-python/tmdb3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	transmission? ( dev-python/transmissionrpc[${PYTHON_USEDEP}] )
"
DEPEND+=" test? ( dev-python/nose[${PYTHON_USEDEP}] )"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" dev-python/paver[${PYTHON_USEDEP}]"
else
	S="${WORKDIR}/${MY_P}"
fi

python_prepare_all() {
	# Prevent setup from grabbing nose from pypi
	sed -e /setup_requires/d -i pavement.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cp -lr tests setup.cfg "${BUILD_DIR}" || die
	run_in_build_dir nosetests -v --attr=!online > "${T}/tests-${EPYTHON}.log" \
		|| die "Tests fail with ${EPYTHON}"
}
