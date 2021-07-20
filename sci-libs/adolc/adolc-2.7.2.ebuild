# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin-or/ADOL-C"
else
	SRC_URI="https://github.com/coin-or/ADOL-C/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/ADOL-C-releases-${PV}"
fi

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/2"
IUSE="+boost mpi sparse"

RDEPEND="
	boost? ( dev-libs/boost:0= )
	mpi? ( sys-cluster/ampi:0= )
	sparse? ( sci-libs/colpack:0= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-no-colpack.patch
	"${FILESDIR}"/${PN}-2.5.0-pkgconfig-no-ldflags.patch
	"${FILESDIR}"/${PN}-2.6.2-dash.patch
	"${FILESDIR}"/${P}-swig-python-configure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Disabling Python for now because swig build
	# needs work. Revisit with >=2.7.3.
	# https://bugs.gentoo.org/730750
	# https://github.com/coin-or/ADOL-C/issues/20
	econf \
		--disable-python \
		--disable-static \
		--enable-advanced-branching \
		--enable-atrig-erf \
		$(use_enable mpi ampi) \
		$(use_enable sparse) \
		$(use_with boost) \
		$(use_with sparse colpack "${EPREFIX}"/usr)
}

src_test() {
	# 'check' target is unrelated to checking lib works
	# ('check' is more like distcheck)
	emake test
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
