# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils versionator

MY_PN="ITVal"
MY_PV="$(get_version_component_range 3)"
MY_PV="${MY_PV/p/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Iptables policy testing and validation tool"
HOMEPAGE="http://itval.sourceforge.net"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/fddl"
DEPEND="
	sys-devel/flex
	sys-devel/bison
	${RDEPEND}
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog README RELEASE )

src_install() {
	default
	doman man/ITVal.n
}
