# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The best variant of the Yacc parser generator"
HOMEPAGE="https://invisible-island.net/byacc/byacc.html"
SRC_URI="ftp://ftp.invisible-island.net/byacc/${P}.tgz"
# Seems to be unreliable (unstable tarballs): bug #820167.
#SRC_URI="https://invisible-mirror.net/archives/byacc/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

DOCS=( ACKNOWLEDGEMENTS AUTHORS CHANGES NEW_FEATURES NOTES README )

src_configure() {
	econf --program-prefix=b
}
