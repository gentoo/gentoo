# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm toolchain-funcs

RH_REV=3
DESCRIPTION="Print out increasing, decreasing, random, or redundant data"
HOMEPAGE="http://freshmeat.net/projects/bsd-jot/"
SRC_URI="http://www.mit.edu/afs/athena/system/rhlinux/athena-${PV}/free/SRPMS/athena-${P}-${RH_REV}.src.rpm"
S="${WORKDIR}/athena-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_prepare() {
	default
	tc-export CC
}
