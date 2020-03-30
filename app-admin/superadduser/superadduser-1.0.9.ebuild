# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Interactive adduser script from Slackware"
HOMEPAGE="http://www.interlude.org.uk/unix/slackware/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 m68k ~mips ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="sys-apps/shadow"

S=${WORKDIR}

src_install() {
	dosbin "${FILESDIR}"/${PV}/superadduser
	doman "${FILESDIR}"/superadduser.8
}
