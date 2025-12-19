# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

MY_PV="${PV/_beta/b}"

DESCRIPTION="Sequence analysis using profile hidden Markov models"
HOMEPAGE="http://hmmer.org/"
SRC_URI="http://eddylab.org/software/${PN}3/${MY_PV}/hmmer-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_ppc_altivec cpu_flags_x86_sse gsl mpi test"
RESTRICT="!test? ( test )"

RDEPEND="
	mpi? ( virtual/mpi )
	gsl? ( sci-libs/gsl:= )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1_beta2-fix-perl-shebangs.patch
	"${FILESDIR}"/${PN}-3.1_beta2-makefile.patch
)

src_configure() {
	# make build verbose, bug #429308
	export V=1

	lto-guarantee-fat

	econf \
		--disable-pic \
		--enable-threads \
		$(use_enable cpu_flags_ppc_altivec vmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable mpi) \
		$(use_with gsl)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	strip-lto-bytecode
	dodoc Userguide.pdf

	insinto /usr/share/hmmer
	doins -r tutorial
}
