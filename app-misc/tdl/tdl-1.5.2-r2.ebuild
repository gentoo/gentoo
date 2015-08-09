# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Command line To Do List manager"
HOMEPAGE="http://www.rc0.org.uk/tdl/"
SRC_URI="
	http://www.rpcurnow.force9.co.uk/tdl/${P}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PN}-screenshot.png.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc readline"

RDEPEND="
	sys-libs/ncurses
	sys-libs/readline"
DEPEND="${RDEPEND}
	sys-apps/sed
	sys-apps/texinfo
	doc? ( virtual/texi2dvi )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-ldflags.patch \
		"${FILESDIR}"/${P}-list.c.patch \
		"${FILESDIR}"/${P}-main.c.patch \
		"${FILESDIR}"/${P}-man.patch

	tc-export CC
}

src_configure() {
	local myconf="--prefix=${EPREFIX}/usr"

	if ! use readline; then
		myconf="${myconf} --without-readline"

		sed -i 's#\($(LIB_READLINE)\)#\1 -lncurses##g' "${S}"/Makefile.in || die
	fi
	sed -i 's#-ltermcap#-lncurses#g' "${S}"/configure || die

	# XXX: do not replace with econf.
	"${S}"/configure ${myconf} || die "configure failed, sorry!"
}

src_compile() {
	emake all tdl.info tdl.html tdl.txt
	use doc && emake tdl.dvi tdl.ps tdl.pdf
}

src_install() {
	local i

	dodoc README NEWS tdl.txt "${WORKDIR}"/screenshot.png
	doinfo tdl.info
	dohtml tdl.html

	dobin tdl
	doman tdl.1

	for i in tdl{a,l,d,g}
	do
		dosym tdl /usr/bin/${i}
		dosym tdl.1 /usr/share/man/man1/${i}.1
	done

	if use doc; then
		dodoc tdl.dvi tdl.ps tdl.pdf
	fi
}
