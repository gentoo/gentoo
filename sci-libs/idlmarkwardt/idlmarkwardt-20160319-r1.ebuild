# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Craig Markwardt IDL procedures (MPFIT, CMSVLIB, etc)"
HOMEPAGE="http://cow.physics.wisc.edu/~craigm/idl/idl.html"
SRC_URI="http://www.physics.wisc.edu/~craigm/idl/down/cmtotal.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Markwardt"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/gdl"

src_install() {
	insinto /usr/share/gnudatalanguage/idlmarkwardt
	doins *.pro
	dodoc *README
}
