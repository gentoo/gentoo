# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools usr-ldscript

DESCRIPTION="System Utilities Based on Sysfs"
HOMEPAGE="http://linux-diag.sourceforge.net/Sysfsutils.html"
SRC_URI="mirror://sourceforge/linux-diag/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_prepare() {
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die # bug #467642

	# Workaround maintainer mode
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dodoc docs/libsysfs.txt
	gen_usr_ldscript -a sysfs

	# We do not distribute this
	rm -f "${ED}"/usr/bin/dlist_test "${ED}"/usr/lib*/libsysfs.la || die
}
