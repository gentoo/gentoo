# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic

MY_P=${PN}-${PV/_/}
DESCRIPTION="Imposes stressful loads on different aspects of the system"
HOMEPAGE="http://people.seas.harvard.edu/~apw/stress"
SRC_URI="http://people.seas.harvard.edu/~apw/stress/${MY_P}.tar.gz -> ${MY_P}-r1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86"
IUSE="static"

S=${WORKDIR}/${MY_P}

src_prepare() {
	use static && append-ldflags -static
}
