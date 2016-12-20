# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Craig Markwardt IDL procedures (MPFIT, CMSVLIB, etc)"
HOMEPAGE="http://cow.physics.wisc.edu/~craigm/idl/idl.html"
SRC_URI="http://www.physics.wisc.edu/~craigm/idl/down/cmtotal.tar.gz -> ${P}.tar.gz"

LICENSE="Markwardt"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/gdl"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/gnudatalanguage/${PN}
	doins *.pro
	dodoc *README
}
