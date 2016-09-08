# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="sqlite,xml"

inherit python-single-r1

DESCRIPTION="A full featured Python IDE using PyQt and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"
LICENSE="GPL-3"
SLOT="6"

MY_P=${PN}${SLOT}-${PV}
BASE_URI="mirror://sourceforge/eric-ide/${PN}${SLOT}/stable/${PV}"
SRC_URI="${BASE_URI}/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

PLOCALES="cs de en es fr it pt ru tr zh-CN"
for L in ${PLOCALES}; do
	SRC_URI+=" l10n_${L}? ( ${BASE_URI}/${PN}${SLOT}-i18n-${L/-/_}-${PV}.tar.gz )"
	IUSE+=" l10n_${L}"
done
unset L

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.14.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt4-4.10[${PYTHON_USEDEP},X,help,sql,svg,webkit]
	>=dev-python/qscintilla-python-2.8[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/coverage-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.2[${PYTHON_USEDEP}]
	!dev-util/eric:4
	!dev-util/eric:5
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}

DOCS=(changelog README{,-i18n}.rst THANKS)

src_prepare() {
	default

	# Delete internal copies of dev-python/chardet and dev-python/pygments
	rm -fr eric/ThirdParty/{CharDet,Pygments} || die

	# Delete internal copy of dev-python/coverage
	rm -fr eric/DebugClients/Python{,3}/coverage || die
	sed -i -e 's/from DebugClients\.Python3\?\.coverage/from coverage/' \
		$(grep -lr 'from DebugClients\.Python3\?\.coverage' .) || die

	# Fix desktop files (bug 458092)
	sed -i -e '/^Categories=/s:Python:X-&:' eric/eric6{,_webbrowser}.desktop || die
}

src_install() {
	"${PYTHON}" install.py \
		-b "${EPREFIX}/usr/bin" \
		-d "$(python_get_sitedir)" \
		-i "${D}" \
		-c \
		-z \
		--pyqt=4 \
		|| die

	python_optimize
	einstalldocs
}
