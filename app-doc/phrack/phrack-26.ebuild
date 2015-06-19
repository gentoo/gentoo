# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/phrack/phrack-26.ebuild,v 1.18 2015/02/14 15:26:15 mrueg Exp $

EAPI=5

MY_P=${PN}${PV}
DESCRIPTION="A Hacker magazine by the community, for the community"
HOMEPAGE="http://www.phrack.org/"
SRC_URI="http://www.phrack.org/archives/tgz/${MY_P}.tar.gz"

LICENSE="phrack"
SLOT="${PV}"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/doc/${PN}
	doins *
}
