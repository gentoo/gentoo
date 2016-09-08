# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
DESCRIPTION="Server statics collector supporting many FPS games"
HOMEPAGE="https://sourceforge.net/projects/qstat/"
SRC_URI="mirror://sourceforge/qstat/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ppc ppc64 x86"
IUSE="debug"

DEPEND="!sys-cluster/torque"

src_prepare() {
	# bug #530952
	sed -i -e 's/strndup/l_strndup/g' qstat.c || die
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	DOCS="CHANGES.txt COMPILE.txt template/README.txt" default
	dosym qstat /usr/bin/quakestat
	dohtml template/*.html qstatdoc.html
}
