# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# We could depend on dev-python/cherrypy when USE=server, but
# that is an optional component ...
# Same for dev-python/tornado and USE=client ... so why not???
# pypy is viable but better with a cutdown set of deps

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="threads(+)?"

MY_PN="WebSocket-for-Python"

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Lawouach/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Lawouach/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="WebSocket client and server library for Python 2 and 3 as well as PyPy"
HOMEPAGE="https://github.com/Lawouach/WebSocket-for-Python"

LICENSE="BSD"
SLOT="0"
IUSE="+client +server test +threads"
RESTRICT="!test? ( test )"
# doc build requires sphinxcontrib ext packages absent from portage

RDEPEND=">=dev-python/greenlet-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	client? ( >=dev-python/tornado-3.1[${PYTHON_USEDEP}] )
	server? ( >=dev-python/cherrypy-3.2.4[${PYTHON_USEDEP}] )"

DEPEND="test? (
		>=dev-python/cherrypy-3.2.4[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.1-python3.7+-compatibility.patch
)

python_test() {
	# testsuite displays an issue with mock under py3 but is non fatal
	"${EPYTHON}" -m unittest discover || die "Tests failed under ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	use client || rm -rf "${D}$(python_get_sitedir)"/ws4py/client
	use server || rm -rf "${D}$(python_get_sitedir)"/ws4py/server
}
