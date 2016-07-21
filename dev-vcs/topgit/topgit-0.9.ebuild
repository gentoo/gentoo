# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bash-completion-r1

DESCRIPTION="A different patch queue manager"
HOMEPAGE="https://github.com/greenrd/topgit"
SRC_URI="https://github.com/greenrd/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-apps/sed
	virtual/awk"
RDEPEND="dev-vcs/git"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	# Needed because of "hardcoded" paths
	emake prefix="/usr" sharedir="/usr/share/doc/${PF}"
}

src_install() {
	emake prefix="${D}/usr" sharedir="${D}/usr/share/doc/${PF}" install

	newbashcomp contrib/tg-completion.bash tg
	dodoc README
}
