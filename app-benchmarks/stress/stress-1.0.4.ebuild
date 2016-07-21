# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit flag-o-matic

MY_P=${PN}-${PV/_/}
DESCRIPTION="Imposes stressful loads on different aspects of the system"
HOMEPAGE="http://people.seas.harvard.edu/~apw/stress"
SRC_URI="http://weather.ou.edu/~apw/projects/stress/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="static"

S=${WORKDIR}/${MY_P}

src_prepare() {
	use static && append-ldflags -static
}
