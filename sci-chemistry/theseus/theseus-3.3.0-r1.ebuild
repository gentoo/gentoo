# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib toolchain-funcs

DESCRIPTION="Maximum likelihood superpositioning and analysis of macromolecular structures"
HOMEPAGE="http://www.theseus3d.org/"
SRC_URI="http://www.theseus3d.org/src/${PN}_${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-libs/gsl:=
	|| (
		sci-biology/muscle
		sci-biology/probcons
		sci-biology/mafft
		sci-biology/t-coffee
		sci-biology/kalign
		sci-biology/clustalw:2
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${PN}_src/

src_prepare() {
	cat >> make.inc <<- EOF
	ARCH = $(tc-getAR)
	ARCHFLAGS = -rvs
	RANLIB = $(tc-getRANLIB)
	LOCALLIBDIR = "${EPREFIX}/usr/$(get_libdir)
	SYSLIBS = $($(tc-getPKG_CONFIG) --libs gsl) -lpthread
	LIBS = -ldistfit -lmsa -ldssplite -ldltmath -lDLTutils -ltheseus
	LIBDIR = -L./lib
	INSTALLDIR = "${ED}"/usr/bin
	OPT =
	WARN =
	CFLAGS = ${CFLAGS} -std=c11 \$(WARN)
	CC = $(tc-getCC)
	EOF

	sed \
		-e 's|theseus:|theseus: libs|g' \
		-e '/-o theseus/s:$(CC):$(CC) ${LDFLAGS}:g' \
		-i Makefile || die

	sed \
		-e 's:/usr/bin/sed:sed:g' \
		-e "s:/usr/local/bin/:/usr/bin/:g" \
		-e "s:/usr/bin/:${EPREFIX}/usr/bin/:g" \
		-i theseus_align || die
}

src_compile() {
	emake ltheseus
	default
}

src_install() {
	dobin theseus theseus_align
	dodoc theseus_man.pdf README AUTHORS
	use examples && insinto /usr/share/${PN} && doins -r examples
}
