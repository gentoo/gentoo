# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Sequence analysis using profile hidden Markov models"
HOMEPAGE="http://hmmer.org/"
SRC_URI="http://eddylab.org/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cpu_flags_ppc_altivec cpu_flags_x86_sse gsl mpi test"
RESTRICT="!test? ( test )"

RDEPEND="
	mpi? ( virtual/mpi )
	gsl? ( sci-libs/gsl:= )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

src_configure() {
	# make build verbose, bug #429308
	export V=1

	# a user guide recommendation
	filter-flags '-ffast-math'

	# Foce '-O3' as it is the default CFLAGS in the upstream source
	replace-flags '-O?' '-O3'

	# When using bundled gsl, march optimizations might result in test fails (possibly due to violation of tolerance constraints).
	# Therefore, it is safe to force '-march=x86-64' when using bundled gsl now
	if ! use gsl && [[ $(uname -m) == "x86_64"* ]] ; then
		filter-flags '-march*'
		filter-flags '-mtune*'
		append-flags '-march=x86-64 -mtune=generic '
	fi

	econf \
		--disable-pic \
		--enable-threads \
		$(use_enable cpu_flags_ppc_altivec vmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable mpi) \
		$(use_with gsl)

}

src_compile() {
	emake
}

src_install() {
	default
	dodoc Userguide.pdf

	insinto /usr/share/hmmer
	doins -r tutorial
}
