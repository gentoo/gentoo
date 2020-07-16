# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
SRC_URI="http://www.w3.org/Tools/HTML-XML-utils/${P}.tar.gz"
HOMEPAGE="http://www.w3.org/Tools/HTML-XML-utils/"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-linux ~ppc-macos ~x86-macos"

RESTRICT="test"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e "/doc_DATA = COPYING/d" -i Makefile.in || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
}
