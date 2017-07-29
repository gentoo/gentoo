# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} != 99999999 ]]; then
	SRC_URI="https://idlastro.gsfc.nasa.gov/ftp/astron.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}"
else
	inherit git-r3
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/wlandsman/IDLAstro.git"
	KEYWORDS=""
fi

DESCRIPTION="Astronomical user routines for IDL"
HOMEPAGE="https://idlastro.gsfc.nasa.gov/"

LICENSE="BSD-2 BSD"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/gdl"

src_install() {
	insinto /usr/share/gnudatalanguage/${PN}
	doins -r pro/*
	dodoc *txt text/*
}
