# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}6-${PV}
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="sqlite,xml"
inherit python-single-r1 xdg-utils

DESCRIPTION="A full featured Python IDE using PyQt and QScintilla"
HOMEPAGE="https://eric-ide.python-projects.org/"
SRC_URI="mirror://sourceforge/eric-ide/${PN}6/stable/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.14.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.7.1[${PYTHON_USEDEP},gui,network,printsupport,sql,svg,widgets]
	>=dev-python/qscintilla-python-2.9.4-r1[${PYTHON_USEDEP},qt5]
"
RDEPEND="${DEPEND}
	|| (
		dev-python/PyQt5[${PYTHON_USEDEP},help,webkit]
		dev-python/PyQt5[${PYTHON_USEDEP},help,webengine]
	)
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	>=dev-python/coverage-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.2.0[${PYTHON_USEDEP}]
	!dev-util/eric:4
	!dev-util/eric:5
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}

DOCS=( changelog README.rst THANKS )

src_prepare() {
	default

	# Delete internal copies of dev-python/chardet and dev-python/pygments
	rm -fr eric/ThirdParty/{CharDet,Pygments} || die

	# Delete internal copy of dev-python/coverage
	rm -fr eric/DebugClients/Python{,3}/coverage || die
	sed -i -e 's/from DebugClients\.Python3\?\.coverage/from coverage/' \
		$(grep -lr 'from DebugClients\.Python3\?\.coverage' .) || die
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

pkg_postinst(){
	xdg_desktop_database_update

	if ! has_version dev-python/enchant; then
		elog "You might want to install dev-python/pyenchant"
		elog "for spell checking."
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
