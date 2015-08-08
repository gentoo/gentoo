# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fixheadtails flag-o-matic toolchain-funcs

DESCRIPTION="program for applying patches that patch cannot apply because of conflicting changes"
HOMEPAGE="http://neil.brown.name/wiggle http://neil.brown.name/git?p=wiggle"
SRC_URI="http://neil.brown.name/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

# The 'p' tool does support bitkeeper, but I'm against just dumping it in here
# due to it's size.  I've explictly listed every other dependancy here due to
# the nature of the shell program 'p'
RDEPEND="
	dev-util/diffstat
	dev-util/patchutils
	sys-apps/diffutils
	sys-apps/findutils
	virtual/awk
	sys-apps/grep
	sys-apps/less
	sys-apps/sed
	sys-apps/coreutils
	sys-devel/patch"
DEPEND="${RDEPEND}
	sys-apps/groff
	test? ( sys-process/time )"

src_prepare() {
	# Fix the reference to the help file so `p help' works
	sed -i "s:\$0.help:${EPREFIX}/usr/share/wiggle/p.help:" p || die "sed failed on p"

	# Don't add Neil Brown's default sign off line to every patch
	sed -i '/$CERT/,+4s,^,#,' p || die "sed failed on p"

	# Use prefixed time binary
	sed -i "s:/usr/bin/time:${EPREFIX}/usr/bin/time:" dotest || die "sed failed on dotest"

	sed \
		-e "s:-lncurses:$($(tc-getPKG_CONFIG) --libs ncurses):g" \
		-i Makefile || die

	ht_fix_file p

	append-cppflags -I.
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall" ${PN}
}

src_install() {
	dobin wiggle p
	doman wiggle.1
	dodoc ANNOUNCE INSTALL TODO DOC/diff.ps notes
	insinto /usr/share/wiggle
	doins p.help
}
