# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Library to Access SMI MIB Information"
HOMEPAGE="https://www.ibr.cs.tu-bs.de/projects/libsmi/"
SRC_URI="https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE="static-libs"
RESTRICT="test"

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	# sming test is known to fail and some other fail if LC_ALL!=C:
	# https://mail.ibr.cs.tu-bs.de/pipermail/libsmi/2008-March/001014.html
	sed -i '/^[[:space:]]*smidump-sming.test \\$/d' test/Makefile
	LC_ALL=C emake -j1 check
}

src_install() {
	default

	dodoc ANNOUNCE ChangeLog README THANKS TODO \
		doc/{*.txt,smi.dia,smi.dtd,smi.xsd} smi.conf-example

	find "${ED}" -name '*.la' -delete || die
}
