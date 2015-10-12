# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils portability python-r1 versionator

#PATCHSET="${PV##*_p}"
MY_PN="${PN/-data}mr"
MY_PV="$(replace_version_separator 3 _ ${PV%%_p*})"
MY_MAJOR="$(get_version_component_range 1-3)"

DESCRIPTION="The Collaborative Computing Project for NMR - Data"
HOMEPAGE="http://www.ccpn.ac.uk/ccpn"
SRC_URI="http://www2.ccpn.ac.uk/download/${MY_PN}/analysis${MY_PV}.tar.gz"
[[ -n ${PATCHSET} ]] && SRC_URI+=" https://dev.gentoo.org/~jlec/distfiles/ccpn-update-${MY_MAJOR}-${PATCHSET}.patch.xz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	!<sci-chemistry/ccpn-${PVR}"
DEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}"/ccpnmr/ccpnmr2.4

src_prepare() {
	[[ -n ${PATCHSET} ]] && \
		epatch "${WORKDIR}"/ccpn-update-${MY_MAJOR}-${PATCHSET}.patch
	cp "${FILESDIR}"/312+ccpn_rhf22_2013-10-02-16-17-30-923_00001.xml data/ccp/nmr/NmrExpPrototype/ || die
}

src_install() {
	local i pydocs in_path ein_path

	dodir /usr/share/doc/${PF}/html
	sed \
		-e "s:../ccpnmr2.1:${EPREFIX}/usr/share/doc/${PF}/html:g" \
		../doc/index.html > "${ED}"/usr/share/doc/${PF}/html/index.html || die
	treecopy $(find python/ -name doc -type d) "${ED}"/usr/share/doc/${PF}/html/

	pydocs="$(find python -name doc -type d)"

	symlinking() {
		in_path=$(python_get_sitedir)/ccpn
		ein_path="${in_path#${EPREFIX}}"
		dosym ../../../../share/doc/${PF}/html ${ein_path}/doc
		for i in ${pydocs}; do
			dosym /usr/share/doc/${PF}/html/${i} ${ein_path}/${i}
		done
		dosym /usr/share/ccpn/data ${ein_path}/data
		dosym /usr/share/ccpn/model ${ein_path}/model
	}
	python_foreach_impl symlinking

	dohtml -r doc/*
	insinto /usr/share/ccpn
	doins -r data model
}
