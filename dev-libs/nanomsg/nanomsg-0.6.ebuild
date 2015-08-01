# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nanomsg/nanomsg-0.6.ebuild,v 1.1 2015/08/01 16:06:06 djc Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib

DESCRIPTION="High-performance messaging interface for distributed applications"
HOMEPAGE="http://nanomsg.org/"
SRC_URI="https://github.com/nanomsg/nanomsg/releases/download/0.6-beta/${P}-beta.tar.gz"

LICENSE="MIT"
SLOT="0/0.2.2"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~x86"
IUSE="doc static-libs"

DEPEND="doc? (
		app-text/asciidoc
		app-text/xmlto
	)"
RDEPEND=""

S="${WORKDIR}/${P}-beta"

src_prepare() {
	sed -i -e 's/doc_DATA/html_DATA/' Makefile.am || die

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		--htmldir "/usr/share/doc/${PF}/html"
	)
	if multilib_is_native_abi; then
		myeconfargs+=(
			$(use_enable doc)
		)
	else
		myeconfargs+=(
			--disable-doc
			--disable-nanocat
			--disable-symlinks
		)
	fi
	autotools-utils_src_configure
}
