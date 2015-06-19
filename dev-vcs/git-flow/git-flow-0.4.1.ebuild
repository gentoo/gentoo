# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-flow/git-flow-0.4.1.ebuild,v 1.3 2014/08/15 19:58:26 johu Exp $

EAPI=5

MY_PN="${PN/-/}"
COMP_PN="${PN}-completion"
COMP_PV="0.4.2.2"
COMP_P="${COMP_PN}-${COMP_PV}"
inherit eutils bash-completion-r1

DESCRIPTION="Git extensions to provide high-level repository operations for Vincent Driessen's branching model"
HOMEPAGE="https://github.com/nvie/gitflow"
SRC_URI="https://github.com/nvie/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
https://github.com/bobthecow/${COMP_PN}/archive/${COMP_PV}.tar.gz -> ${COMP_P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-util/shflags
	dev-vcs/git
"

DOCS=( AUTHORS Changes.mdown README.mdown )

PATCHES=( "${FILESDIR}/${P}-unbundle-shflags.patch" )

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
