# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/fasta/fasta-36.3.5e.ebuild,v 1.2 2015/01/29 21:20:44 mgorny Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="FASTA is a DNA and Protein sequence alignment software package"
HOMEPAGE="http://fasta.bioch.virginia.edu/fasta_www2/fasta_down.shtml"
SRC_URI="http://faculty.virginia.edu/wrpearson/${PN}/${PN}36/${P}.tar.gz"

LICENSE="fasta"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="debug cpu_flags_x86_sse2 test"

DEPEND="test? ( app-shells/tcsh )"
RDEPEND=""

src_prepare() {
	CC_ALT=
	CFLAGS_ALT=
	ALT=

	use debug && append-flags -DDEBUG

	if [[ $(tc-getCC) == *icc* ]]; then
		CC_ALT=icc
		ALT="${ALT}_icc"
	else
		CC_ALT=$(tc-getCC)
		use x86 && ALT="32"
		use amd64 && ALT="64"
	fi

	if use cpu_flags_x86_sse2 ; then
		ALT="${ALT}_sse2"
		append-flags -msse2
		[[ $(tc-getCC) == *icc* ]] || append-flags -ffast-math
	fi

	export CC_ALT="${CC_ALT}"
	export ALT="${ALT}"

	epatch "${FILESDIR}"/${P}-ldflags.patch

	sed \
		-e 's:-ffast-math::g' \
		-i make/Makefile* || die

}

src_compile() {
	cd src || die
	emake -f ../make/Makefile.linux${ALT} CC="${CC_ALT} ${CFLAGS}" HFLAGS="${LDFLAGS} -o" all
}

src_test() {
	cd test || die
	FASTLIBS="../conf" bash test.sh || die
}

src_install() {
	local bin
	dobin bin/*

	pushd bin > /dev/null || die
	for bin in *36; do
		dosym ${bin} /usr/bin/${bin%36} || die
	done
	popd

	insinto /usr/share/${PN}
	doins -r conf/* data seq

	doman doc/{prss3.1,fasta36.1,fasts3.1,fastf3.1,ps_lav.1,map_db.1}
	dodoc  FASTA_LIST README doc/{README.versions,readme*,fasta*,changes*}
}
