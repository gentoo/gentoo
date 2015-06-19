# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/onesis/onesis-2.0.2.ebuild,v 1.1 2010/09/29 11:31:47 cla Exp $

MY_P="oneSIS-${PV/_}"

DESCRIPTION="Diskless computing made easy"
HOMEPAGE="http://onesis.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	make prefix="${D}" INSTALLDIRS=vendor install || die "make install failed"
}
