# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5


DESCRIPTION="A collection of Polish translations of Linux manual pages"
HOMEPAGE="http://sourceforge.net/projects/manpages-pl/"
SRC_URI="mirror://sourceforge/manpages-pl/manpages-pl-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DOCS=( AUTHORS README )

S="${WORKDIR}/manpages-pl-${PV}"

src_prepare() {
	epatch_user
	#mans provided by other packages
	mans="generated/man1/groups.1 po/man1/groups.1.po"

	for man in ${mans}; do
		rm ${man} || die
	done
}
