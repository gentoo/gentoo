# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Prototype ncRNA genefinder"
HOMEPAGE="http://selab.janelia.org/software.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	sci-biology/hmmer:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default
	sed \
		-e "s:^CC.*:CC = $(tc-getCC):" \
		-e "/^AR/s:ar:$(tc-getAR):g" \
		-e "/^RANLIB/s:ranlib:$(tc-getRANLIB):g" \
		-e "/CFLAGS/s:=.*$:= ${CFLAGS}:" \
		-i {src,squid,squid02}/Makefile || die
	rm -v squid*/*.a || die
}

src_compile() {
	local d
	for d in squid squid02 src; do
		emake -C ${d}
	done
}

src_install() {
	dobin src/{cfgbuild,eqrna,eqrna_sample,rnamat_main} scripts/*

	newdoc 00README README
	dodoc -r documentation/.

	insinto /usr/share/${PN}/data
	doins -r lib/.
	insinto /usr/share/${PN}/demos
	doins -r Demos/.

	# Sets the path to the QRNA data files
	doenvd "${FILESDIR}"/26qrna
}
