# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="fast-export history from a CVS repository or RCS collection"
HOMEPAGE="http://www.catb.org/~esr/cvs-fast-export/"
SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT=test # upstream does not ship some tests in tarball

BDEPEND="dev-ruby/asciidoctor"

PATCHES=( "${FILESDIR}/${PN}-1.61-Makefile.patch" )

src_prepare() {
	default
	tc-export CC
	export prefix="${EPREFIX}"/usr
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
	dodoc {NEWS,README,TODO,hacking,reporting-bugs}.adoc
}
