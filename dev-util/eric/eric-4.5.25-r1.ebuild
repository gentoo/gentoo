# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
# 2.4 and 2.5 are restricted to avoid conditional dependency on dev-python/simplejson
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-jython 2.7-pypy-*"
PYTHON_USE_WITH="sqlite xml"

inherit eutils python

DESCRIPTION="A full featured Python IDE using PyQt4 and QScintilla"
HOMEPAGE="http://eric-ide.python-projects.org/"

SLOT="4"
MY_PV=${PV/_rc/-RC}
MY_P=${PN}${SLOT}-${MY_PV}

BASE_URI="mirror://sourceforge/eric-ide/${PN}${SLOT}/stable/${MY_PV}"
SRC_URI="${BASE_URI}/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="kde"

PLOCALES="cs de en es fr it ru tr zh-CN"
for L in ${PLOCALES}; do
	SRC_URI+=" l10n_${L}? ( ${BASE_URI}/${PN}${SLOT}-i18n-${L/zh-CN/zh_CN.GB2312}-${MY_PV}.tar.gz )"
	IUSE+=" l10n_${L}"
done
unset L

DEPEND="
	>=dev-python/sip-4.12.4
	>=dev-python/PyQt4-4.9.6-r1[X,help,svg,webkit]
	>=dev-python/qscintilla-python-2.3
	kde? ( kde-base/pykde4 )
"
RDEPEND="${DEPEND}
	>=dev-python/chardet-2.0.1
	>=dev-python/coverage-3.0.1
	>=dev-python/pygments-1.5
"

S=${WORKDIR}/${MY_P}

PYTHON_VERSIONED_EXECUTABLES=("/usr/bin/.*")

src_prepare() {
	epatch "${FILESDIR}/eric-4.5-no-interactive.patch"
	use kde || epatch "${FILESDIR}/eric-4.4-no-pykde.patch"

	# Delete internal copies of dev-python/chardet,
	# dev-python/pygments and dev-python/simplejson
	rm -fr eric/ThirdParty

	# Delete internal copy of dev-python/coverage
	rm -fr eric/DebugClients/Python{,3}/coverage
	sed -i -e 's/from DebugClients\.Python3\?\.coverage/from coverage/' \
		$(grep -lr 'from DebugClients\.Python3\?\.coverage' .) || die
}

src_install() {
	installation() {
		"$(PYTHON)" install.py \
			-z \
			-b "${EPREFIX}/usr/bin" \
			-i "${T}/images/${PYTHON_ABI}" \
			-d "${EPREFIX}$(python_get_sitedir)" \
			-c
	}
	python_execute_function installation
	python_merge_intermediate_installation_images "${T}/images"

	doicon eric/icons/default/eric.png
	make_desktop_entry "eric4 --nosplash" eric4 eric "Development;IDE;Qt"
}

pkg_postinst() {
	python_mod_optimize eric4{,config.py,plugins}

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

pkg_postrm() {
	python_mod_cleanup eric4{,config.py,plugins}
}
