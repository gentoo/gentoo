# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="PLOD is a tool designed to help administrators (and others) keep
track of their daily activities."
HOMEPAGE="http://www.deer-run.com/~hal/"
SRC_URI="http://www.far2wise.net/plod/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"

	# Get rid of this nasty /usr/local paths
	einfo "Patching paths"
	sed -e 's#/usr/local#/usr#' -i plod
}

src_install() {
	dobin plod
	dodoc README
	doman plod.1.gz

	insinto /etc
	doins "${FILESDIR}"/plodrc
}
