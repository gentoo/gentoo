# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Tools for counting Source Lines of Code (SLOC) for a large number of languages"
HOMEPAGE="http://www.dwheeler.com/sloccount/"
SRC_URI="http://www.dwheeler.com/sloccount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""
RDEPEND="dev-lang/perl
		>=sys-apps/sed-4
		app-shells/bash"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libexec.patch
	epatch "${FILESDIR}"/${P}-coreutils-tail-n-fix.patch
	# support for .ebuild and #!/sbin/runscript:
	epatch "${FILESDIR}"/${P}-gentoo.patch

	sed -i \
		-e 's|^CC=gcc|CFLAGS+=|g' \
		-e 's|$(CC)|& $(CFLAGS) $(LDFLAGS)|g' \
		-e '/^DOC_DIR/ { s/-$(RPM_VERSION)//g }' \
		-e '/^MYDOCS/ { s/[^    =]\+\.html//g }' \
		makefile || die "sed makefile failed"

	#fixed hard-codes libexec_dir in sloccount
	sed -i "s|libexec_dir=|&\"${EPREFIX}\"|" sloccount || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_test() {
	PATH+=":${S}"
	emake test
}

src_install() {
	emake PREFIX="${ED}/usr" DOC_DIR="${ED}/usr/share/doc/${PF}/" install
	dohtml *html
}
