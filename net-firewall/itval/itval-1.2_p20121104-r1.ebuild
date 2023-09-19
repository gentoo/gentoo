# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_IN_SOURCE_BUILD=1
inherit cmake

MY_PN="ITVal"
MY_PV="$(ver_cut 4)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Iptables policy testing and validation tool"
HOMEPAGE="http://itval.sourceforge.net"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/fddl
"
DEPEND="
	${RDEPEND}
	sys-devel/bison
	sys-devel/flex
"
S=${WORKDIR}/${MY_P}
DOCS=( AUTHORS ChangeLog README RELEASE )

src_install() {
	default
	doman man/ITVal.n
}
