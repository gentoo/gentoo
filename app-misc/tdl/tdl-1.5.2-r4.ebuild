# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

MY_PV="$(ver_rs 1- '_')"
DESCRIPTION="Command line To Do List manager"
HOMEPAGE="https://github.com/rc0/tdl"
SRC_URI="https://github.com/rc0/tdl/archive/V${MY_PV}/V${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc readline"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="

DEPEND="
	${RDEPEND}
	sys-apps/texinfo
	doc? ( virtual/texi2dvi )"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${P}-list.c.patch
	"${FILESDIR}"/${P}-main.c.patch
	"${FILESDIR}"/${P}-man.patch
)

DOCS=( README NEWS tdl.txt tdl.html )

src_prepare() {
	default
	tc-export CC
}

src_configure() {
	local myconf=( --prefix="${EPREFIX}"/usr )

	if ! use readline; then
		myconf+=( "${myconf} --without-readline" )
		sed -i 's#\($(LIB_READLINE)\)#\1 -lncurses##g' "${S}"/Makefile.in || die
	fi

	sed -i 's#-ltermcap#-lncurses#g' "${S}"/configure || die
	edo "${S}"/configure "${myconf[@]}"
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
