# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Sequence analysis using profile hidden Markov models"
HOMEPAGE="http://hmmer.org/"
SRC_URI="http://eddylab.org/software/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_ppc_altivec test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}/${P}-fix-perl-shebangs.patch"
	"${FILESDIR}/${P}-fix-build-system-destdir.patch"
)

src_configure() {
	# required to expose pthread_setconcurrency(), #882279
	append-cppflags -D_XOPEN_SOURCE=500

	# prevent stray environmental variable
	# from causing issues in the test phase
	unset TMPDIR

	econf \
		--enable-lfs \
		--enable-threads \
		$(use_enable cpu_flags_ppc_altivec altivec)
}

src_compile() {
	emake AR="$(tc-getAR) rcs"
}

src_install() {
	default

	newlib.a src/libhmmer.a libhmmer2.a
	insinto /usr/include/hmmer2
	doins src/*.h

	dobin squid/{afetch,alistat,compalign,compstruct,revcomp,seqstat,seqsplit,sfetch,shuffle,sreformat,sindex,weight,translate}
	dolib.a squid/libsquid.a
	insinto /usr/include/hmmer2
	doins squid/*.h

	dodoc NOTES Userguide.pdf
	newdoc 00README README

	# rename files due to collisions with hmmer-3
	# in order to make SLOTing possible
	local i

	# first rename man pages...
	pushd "${ED}"/usr/share/man/man1/ >/dev/null || die
	for i in hmm*.1; do
		mv ${i%.1}{,2}.1 || die
	done
	popd >/dev/null || die

	# ... then rename binaries
	pushd "${ED}"/usr/bin/ >/dev/null || die
	for i in hmm*; do
		mv ${i}{,2} || die
	done
	popd >/dev/null || die
}

pkg_postinst() {
	elog "All ${P} binaries have been renamed, in order"
	elog "to avoid collisions with hmmer-3. For instance"
	elog
	elog "    hmmalign -> hmmalign2"
	elog
}
