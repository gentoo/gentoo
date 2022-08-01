# Copyright 1999-2022 Gentoo Authors
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

src_prepare() {
	default
	sed -e "/doc_DATA = COPYING/d" -i Makefile.in || die
}

src_test() {
	# Lots of tests lack a shebang and use bashisms
	emake check SHELL="${BROOT}"/bin/bash
}
