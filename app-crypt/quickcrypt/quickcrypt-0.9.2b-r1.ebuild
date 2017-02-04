# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

MY_P=${P/-/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="gives you a quick MD5 Password from any string"
HOMEPAGE="http://linux.netpimpz.com/quickcrypt/"
SRC_URI="http://linux.netpimpz.com/quickcrypt/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64 ~ia64 ~hppa ~mips"
IUSE=""

DEPEND=">=dev-lang/perl-5.6
	virtual/perl-Digest-MD5"
RDEPEND="${DEPEND}"

DOCS=(
	README BUGS
)

src_install() {
	einstalldocs
	dobin quickcrypt
}
