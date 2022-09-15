# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for handling paper characteristics"
HOMEPAGE="https://github.com/rrthomas/libpaper"
SRC_URI="https://github.com/rrthomas/libpaper/releases/download/v${PV}/${P}.tar.gz"

# paperspecs is public-domain
LICENSE="LGPL-3+ public-domain"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	sys-apps/help2man
"

# False positive (runs within a conditional)
QA_AM_MAINTAINER_MODE=".*help2man.*"

src_configure() {
	econf --enable-relocatable
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die

	dodir /etc
	(paperconf 2>/dev/null || echo a4) > "${ED}"/etc/papersize \
		|| die "papersize config failed"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Run e.g. \"paperconfig -p letter\" as root to use letter-pagesizes"
	fi
}
