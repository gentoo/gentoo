# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Multi-purpose text editor for the X Window System"
HOMEPAGE="https://sourceforge.net/projects/nedit"
SRC_URI="
	https://downloads.sourceforge.net/project/${PN}/${PN}-source/${P}-src.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

RDEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXt
	x11-libs/libX11"
DEPEND="${RDEPEND}
	|| ( dev-util/yacc sys-devel/bison )
	dev-lang/perl"

S="${WORKDIR}/${PN}-${PV}"

PATCHES=(
	  "${FILESDIR}/${P}-ldflags.patch"
	  "${FILESDIR}/${PN}-5.6-security.patch"
	  "${FILESDIR}/${P}-doc.patch"
)

src_prepare() {
	#respecting LDFLAGS, bug #208189
	default
	sed \
		-e "s:bin/:${EPREFIX}/bin/:g" \
		-i Makefile source/preferences.c source/help_data.h source/nedit.c Xlt/Makefile || die
	sed \
		-e "s:nc:neditc:g" -i doc/nc.pod || die
	sed -i -e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:" -e "s:check_tif_rule::" \
		makefiles/Makefile.linux || die
	sed -i -e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:"                  \
		   -e "s:MOTIFDIR=/usr/local:MOTIFDIR=${EPREFIX}/usr:" \
		   -e "s:-lX11:-lX11 -lXmu -liconv:"                   \
		   -e "s:check_tif_rule::"                             \
		makefiles/Makefile.macosx || die
}

src_compile() {
	case "${CHOST}" in
		*-darwin*)
			emake CC="$(tc-getCC)" AR="$(tc-getAR)" macosx
			;;
		*-linux*)
			emake CC="$(tc-getCC)" AR="$(tc-getAR)" linux
			;;
	esac
	if use doc; then
		emake VERSION="NEdit ${PV}" -C doc all
	fi
}

src_install() {
	dobin source/nedit
	newbin source/nc neditc

	make_desktop_entry "${PN}"
	doicon "${WORKDIR}/${PN}.png"

	if use doc; then
		newman doc/nedit.man nedit.1
		newman doc/nc.man neditc.1

		dodoc README ReleaseNotes ChangeLog
		dodoc doc/nedit.doc doc/NEdit.ad doc/faq.txt doc/nedit.html
	fi
}
