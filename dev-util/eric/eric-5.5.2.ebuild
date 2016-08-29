# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="sqlite,xml"

inherit eutils python-single-r1

DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"

SLOT="5"
MY_PV=${PV/_rc/-RC}
MY_P=${PN}${SLOT}-${MY_PV}

BASE_URI="mirror://sourceforge/eric-ide/${PN}${SLOT}/stable/${MY_PV}"
SRC_URI="${BASE_URI}/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

PLOCALES="cs de en es fr it pt ru tr zh-CN"
for L in ${PLOCALES}; do
	SRC_URI+=" l10n_${L}? ( ${BASE_URI}/${PN}${SLOT}-i18n-${L/zh-CN/zh_CN.GB2312}-${MY_PV}.tar.gz )"
	IUSE+=" l10n_${L}"
done
unset L

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.14.3[${PYTHON_USEDEP}]
	>=dev-python/PyQt4-4.10[${PYTHON_USEDEP},X,help,sql,svg,webkit]
	>=dev-python/qscintilla-python-2.7.1[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Avoid file collisions between different slots of eric
	sed -i -e 's/^Icon=eric$/&5/' eric/eric5.desktop || die
	sed -i -e 's/\([^[:alnum:]]\)eric\.png\([^[:alnum:]]\)/\1eric5.png\2/' \
		$(grep -lr 'eric\.png' .) || die
	sed -i -e 's/eric"/eric5"/' \
		$(grep -lr 'eric".*\.png' .) || die
	mv eric/icons/default/eric{,5}.png || die
	mv eric/pixmaps/eric{,5}.png || die
	rm -f eric/APIs/Python/zope-*.api
	rm -f eric/APIs/Ruby/Ruby-*.api

	# Delete internal copies of dev-python/chardet and dev-python/pygments
	rm -fr eric/ThirdParty/{CharDet,Pygments}

	# Delete internal copy of dev-python/coverage
	rm -fr eric/DebugClients/Python{,3}/coverage
	sed -i -e 's/from DebugClients\.Python3\?\.coverage/from coverage/' \
		$(grep -lr 'from DebugClients\.Python3\?\.coverage' .) || die

	# Fix desktop files (bug 458092)
	sed -i -e '/^Categories=/s:Python:X-&:' eric/eric5{,_webbrowser}.desktop || die
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

	doicon eric/icons/default/eric5.png
	dodoc changelog THANKS
}

pkg_postinst() {
	elog "The following packages will give Eric extended functionality:"
	elog "  dev-python/cx_Freeze"
	elog "  dev-python/pyenchant"
	elog "  dev-python/pylint"
	elog "  dev-python/pysvn"
	elog "  dev-vcs/mercurial"
	elog
	elog "This version has a plugin interface with plugin-autofetch from"
	elog "the application itself. You may want to check that as well."
}
