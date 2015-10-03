# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A Library to Access SMI MIB Information"
HOMEPAGE="http://www.ibr.cs.tu-bs.de/projects/libsmi"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	# sming test is known to fail and some other fail if LC_ALL!=C:
	# http://mail.ibr.cs.tu-bs.de/pipermail/libsmi/2008-March/001014.html
	sed -i '/^[[:space:]]*smidump-sming.test \\$/d' test/Makefile
	LC_ALL=C emake -j1 check || die
}

src_install () {
	default
	dodoc smi.conf-example ANNOUNCE ChangeLog README THANKS TODO \
		doc/{*.txt,smi.dia,smi.dtd,smi.xsd}
	prune_libtool_files
}
