# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

RESTRICT=test # upstream does not ship some tests in tarball

src_prepare() {
	default

	tc-export CC
	export prefix=/usr

	# respect CC, CFLAGS and LDFLAGS
	sed \
		-e 's/cc /$(CC) $(LDFLAGS) /' \
		-e 's/^CFLAGS += -O/#&/' \
		-e 's/CFLAGS=/CFLAGS+=/' \
		-i Makefile || die
}

src_compile() {
	# '.adoc.html' rules can't be executed in parallel
	# as they reuse the same 'docbook-xsl.css' file name.
	emake -j1 html
	# Allow full parallelism for the rest
	emake
}

src_install() {
	default
	dodoc README.adoc
}
