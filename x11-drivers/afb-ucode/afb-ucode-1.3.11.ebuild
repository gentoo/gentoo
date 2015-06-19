# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/afb-ucode/afb-ucode-1.3.11.ebuild,v 1.3 2014/07/22 20:31:03 mrueg Exp $

inherit multilib

DESCRIPTION="Binary blob microcode for Elite3D framebuffers to use X, required by xf86-video-sunffb"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://dlc.sun.com/osol/sparc-gfx/downloads/${PN}.tar.bz2
	mirror://gentoo/${PN}.tar.bz2"
IUSE=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* sparc"

RDEPEND="${DEPEND}
	x11-misc/afbinit"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /usr/$(get_libdir)
	doins afb.ucode
}
