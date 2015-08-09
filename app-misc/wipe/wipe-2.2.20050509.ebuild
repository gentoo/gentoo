# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit versionator toolchain-funcs

MY_PV=$(get_version_component_range 3)
MY_SRC=${PN}-wip-${MY_PV}
S="${WORKDIR}/${PN}"

DESCRIPTION="Secure file wiping utility based on Peter Gutman's patterns"
HOMEPAGE="http://wipe.sourceforge.net/"
SRC_URI="mirror://sourceforge/wipe/${MY_SRC}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	econf
	sed -i -e "s:-pipe -O2:${CFLAGS}:" "${S}"/Makefile || die "sed failed"
	emake CC="$(tc-getCC)" || die emake failed
}

src_install() {
	dobin wipe || die "dobin failed"
	doman wipe.1
	dodoc CHANGES README TODO TESTING
}

pkg_postinst() {
	elog "Note that wipe is useless on journalling filesystems, such as reiserfs or XFS."
	elog "See documentation for more info."
}
