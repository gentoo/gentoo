# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Excuses from Bastard Operator from Hell"
HOMEPAGE="http://pages.cs.wisc.edu/~ballard/bofh/"
SRC_URI="mirror://gentoo/fortune-bofh-excuses-${PV}.tar.gz"
S="${WORKDIR}"/${PN/mod-/}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="games-misc/fortune-mod"

src_install() {
	insinto /usr/share/fortune
	doins bofh-excuses.dat bofh-excuses
}
