# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P=${P/-/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="gives you a quick MD5 Password from any string"
HOMEPAGE="http://linux.netpimpz.com/quickcrypt/"
SRC_URI="http://linux.netpimpz.com/quickcrypt/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc alpha amd64 ia64 hppa ~mips"
IUSE=""

DEPEND=">=dev-lang/perl-5.6
	virtual/perl-Digest-MD5"
RDEPEND="${DEPEND}"

src_install() {
	dobin quickcrypt || die
	dodoc README BUGS
}
