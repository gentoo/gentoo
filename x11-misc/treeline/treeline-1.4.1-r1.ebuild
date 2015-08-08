# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils python-single-r1

DESCRIPTION="TreeLine is a structured information storage program"
HOMEPAGE="http://treeline.bellz.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

TLLINGUAS=( de fr )
IUSE+=" ${TLLINGUAS[@]/#/linguas_}"
for lingua in ${TLLINGUAS[@]}; do
	SRC_URI+=" linguas_${lingua}? ( mirror://sourceforge/${PN}/${PN}-i18n-${PV}a.tar.gz )"
done
unset lingua

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
	dev-python/PyQt4[X]
"

S="${WORKDIR}/TreeLine"

src_unpack() {
	unpack ${P}.tar.gz
	local lingua
	for lingua in ${TLLINGUAS}; do
		if use linguas_${lingua}; then
			tar xozf "${DISTDIR}"/${PN}-i18n-${PV}a.tar.gz \
				TreeLine/doc/{readme_${lingua}.trl,README_${lingua}.html} \
				TreeLine/translations/{treeline_${lingua}.{qm,ts},qt_${lingua}.{qm,ts}} || die
		fi
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.3-nocompile.patch

	rm doc/LICENSE || die

	python_export PYTHON_SITEDIR
	sed -i "s;prefixDir, 'lib;'${PYTHON_SITEDIR};" install.py || die
}

src_install() {
	"${EPYTHON}" install.py -x -p /usr/ -d /usr/share/doc/${PF} -b "${D}" || die
}
