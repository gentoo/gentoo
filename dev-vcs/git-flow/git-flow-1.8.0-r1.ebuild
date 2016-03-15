# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN/-/}"
COMP_PN="${PN}-completion"
COMP_PV="0.5.1"
COMP_P="${COMP_PN}-${COMP_PV}"
inherit eutils bash-completion-r1

DESCRIPTION="Git extensions to provide high-level repository operations"
HOMEPAGE="https://github.com/petervanderdoes/gitflow"
SRC_URI="https://github.com/petervanderdoes/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
https://github.com/petervanderdoes/${COMP_PN}/archive/${COMP_PV}.tar.gz -> ${COMP_P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-vcs/git
"

DOCS=( AUTHORS Changes.mdown README.mdown )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	debug-print "$FUNCNAME: applying user patches"
	epatch_user
}

src_compile() {
	true
}

src_install() {
	emake prefix="${D}/usr" install

	[[ ${DOCS[@]} ]] && dodoc "${DOCS[@]}"

	newbashcomp "${WORKDIR}/${COMP_P}/${COMP_PN}.bash" ${PN}
}
