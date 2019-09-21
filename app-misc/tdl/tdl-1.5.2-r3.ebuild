# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Command line To Do List manager"
HOMEPAGE="http://www.rc0.org.uk/tdl/"
SRC_URI="
	http://www.rpcurnow.force9.co.uk/tdl/${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}-screenshot.png.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc readline"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="

DEPEND="
	${RDEPEND}
	sys-apps/sed
	sys-apps/texinfo
	doc? ( virtual/texi2dvi )"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${P}-list.c.patch
	"${FILESDIR}"/${P}-main.c.patch
	"${FILESDIR}"/${P}-man.patch
)

DOCS=( README NEWS tdl.txt "${WORKDIR}"/screenshot.png tdl.html )

src_prepare() {
	default
	tc-export CC
}

src_configure() {
	local myconf=( --prefix=${EPREFIX}/usr )

	if ! use readline; then
		myconf+=( "${myconf} --without-readline" )
		sed -i 's#\($(LIB_READLINE)\)#\1 -lncurses##g' "${S}"/Makefile.in || die
	fi

	sed -i 's#-ltermcap#-lncurses#g' "${S}"/configure || die
	"${S}"/configure "${myconf[@]}" || die "configure failed"
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	emake all tdl.info tdl.html tdl.txt

	if use doc; then
		emake tdl.dvi tdl.ps tdl.pdf
	fi
}

src_install() {
	einstalldocs
	doinfo tdl.info

	dobin tdl
	doman tdl.1

	local i
	for i in tdl{a,l,d,g}
	do
		dosym tdl /usr/bin/${i}
		dosym tdl.1 /usr/share/man/man1/${i}.1
	done

	if use doc; then
		dodoc tdl.dvi tdl.ps tdl.pdf
	fi
}
