# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="sqlite,xml"

inherit python-single-r1

DESCRIPTION="A full featured Python IDE using PyQt and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"
LICENSE="GPL-3"
SLOT="6"

MY_P=${PN}${SLOT}-${PV}
SRC_URI="mirror://sourceforge/eric-ide/${PN}${SLOT}/stable/${PV}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.14.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.5.1[${PYTHON_USEDEP},gui,help,network,printsupport,sql,svg,webkit]
	>=dev-python/qscintilla-python-2.8[qt5,${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/coverage-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.1.3[${PYTHON_USEDEP}]
	!dev-util/eric:4
	!dev-util/eric:5
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}

DOCS=(changelog README.rst THANKS)

src_prepare() {
	default

	# Delete internal copies of dev-python/chardet and dev-python/pygments
	rm -fr eric/ThirdParty/{CharDet,Pygments} || die

	# Delete internal copy of dev-python/coverage
	rm -fr eric/DebugClients/Python{,3}/coverage || die
	sed -i -e 's/from DebugClients\.Python3\?\.coverage/from coverage/' \
		$(grep -lr 'from DebugClients\.Python3\?\.coverage' .) || die

	# Fix desktop files (bug 458092)
	sed -i -re '/^Categories=/s:(Python|QtWeb):X-&:g' eric/eric6{,_{,web}browser}.desktop || die
}

src_install() {
	"${PYTHON}" install.py \
		-b "${EPREFIX}/usr/bin" \
		-d "$(python_get_sitedir)" \
		-i "${D}" \
		-c \
		-z \
		|| die

	python_optimize
	einstalldocs
}
