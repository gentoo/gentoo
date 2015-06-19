# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/cvs-fast-export/cvs-fast-export-1.26.ebuild,v 1.1 2014/11/06 22:58:16 slyfox Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="fast-export history from a CVS repository or RCS collection"
HOMEPAGE="http://www.catb.org/~esr/cvs-fast-export/"
SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-text/asciidoc"

RESTRICT=test # upstream does not ship them in tarball

src_prepare() {
	tc-export CC
	export prefix=/usr

	# respect CC, CFLAGS and LDFLAGS. don't install cvssync
	sed \
		-e 's/cc /$(CC) $(LDFLAGS) /' \
		-e 's/^CFLAGS += -O/#&/' \
		-e 's/CFLAGS=/CFLAGS+=/' \
		-e 's/$(INSTALL).*cvssync/#&/g' \
		-i Makefile || die
}

src_install() {
	default
	dodoc README
}
