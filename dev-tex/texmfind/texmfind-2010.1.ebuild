# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Locate the ebuild providing a certain texmf file through regexp"
HOMEPAGE="https://launchpad.net/texmfind/
	http://home.gna.org/texmfind"
SRC_URI="https://launchpad.net/texmfind/2010/${PV}/+download/texmfind-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
}
