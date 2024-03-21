# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs vcs-clean

DESCRIPTION="Prototype ncRNA genefinder"
HOMEPAGE="http://eddylab.org/software.html"
SRC_URI="
	http://eddylab.org/software/qrna/qrna.tar.gz -> ${P}.tar.gz
	examples? ( mirror://gentoo/qrna-2.0.3c.tar.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-lang/perl
	sci-biology/hmmer:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default
	esvn_clean
	rm -v squid*/*.a || die
}

src_configure() {
	tc-export AR CC RANLIB
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
	if use examples; then
		insinto /usr/share/${PN}/demos
		doins -r "${WORKDIR}"/qrna-2.0.3c/Demos/.
	fi

	# Sets the path to the QRNA data files
	doenvd "${FILESDIR}"/26qrna
}
