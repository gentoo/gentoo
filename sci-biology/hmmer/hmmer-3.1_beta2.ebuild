# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/_beta/b}"

DESCRIPTION="Sequence analysis using profile hidden Markov models"
HOMEPAGE="http://hmmer.org/"
SRC_URI="http://eddylab.org/software/${PN}3/${MY_PV}/hmmer-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="altivec cpu_flags_x86_sse gsl mpi test +threads"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	mpi? ( virtual/mpi )
	gsl? ( sci-libs/gsl:= )"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

S="${WORKDIR}/${PN}-${MY_PV}"
PATCHES=(
	"${FILESDIR}/${PN}-3.1_beta2-fix-perl-shebangs.patch"
	"${FILESDIR}/${PN}-3.1_beta2-fix-header-install-path.patch"
)

src_configure() {
	# make build verbose, bug 429308
	export V=1

	econf \
		--disable-pic \
		$(use_enable altivec vmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable mpi) \
		$(use_enable threads) \
		$(use_with gsl)
}

src_install() {
	default
	dodoc Userguide.pdf

	insinto /usr/share/${PN}
	doins -r tutorial
}
