# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
HOMEPAGE="https://www.w3.org/Tools/HTML-XML-utils/"
SRC_URI="https://www.w3.org/Tools/HTML-XML-utils/${P}.tar.gz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND="
	net-dns/libidn2:=
	net-misc/curl
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-dtd-declaration.patch"
)

src_prepare() {
	default
	sed -e "/doc_DATA = COPYING/d" -i Makefile.in || die
}

src_test() {
	# Lots of tests lack a shebang and use bashisms
	# (seems to be better wrt bashisms as of 8.6, but still no shebang. recheck?)
	# (as of 8.7 4 tests fail with app-shells/dash)
	emake check SHELL="${BROOT}"/bin/bash
}
