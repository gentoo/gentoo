# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MY_P=${P/fortune-mod-/}
DESCRIPTION="Extra fortune cookies for fortune"
HOMEPAGE="http://i-want-a-website.com/about-linux/downloads.shtml"
SRC_URI="http://humorix.org/downloads/${MY_P}.tar.gz"

LICENSE="freedist fairuse"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins humorix-misc humorix-misc.dat
	doins humorix-stories humorix-stories.dat
}
