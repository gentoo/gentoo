# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

PATCHVER="r2"
DESCRIPTION="free MS Word reader"
HOMEPAGE="http://www.winfield.demon.nl"
SRC_URI="http://www.winfield.demon.nl/linux/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${PN}-gentoo-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${WORKDIR}"/${PN}-gentoo-patches-${PATCHVER}
	"${FILESDIR}"/${P}-CVE-2014-8123.patch
)

DOCS=( Docs/{ChangeLog,Exmh,Emacs,FAQ,History,Netscape,QandA,ReadMe,Mozilla,Mutt} )

src_prepare() {
	# Makefile is a symlink to Makefile.Linux, avoid that we patch it by
	# accident using patch <2.7, see bug #435492
	rm Makefile || die

	default

	# Re-add convenience symlink, see above
	ln -s Makefile.Linux Makefile
}

src_configure() {
	true
}

src_compile() {
	emake PREFIX="${EPREFIX}" OPT="${CFLAGS}" CC="$(tc-getCC)" LD="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake -j1 PREFIX="${EPREFIX}" DESTDIR="${D}" global_install

	einstalldocs

	docompress -x /usr/share/doc/${PF}/examples
	docinto examples
	dodoc Docs/testdoc.doc Docs/antiword.php

	doman Docs/antiword.1
}
