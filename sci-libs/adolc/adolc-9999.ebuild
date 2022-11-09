# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin-or/ADOL-C"
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-2.7.2-patches.tar.bz2"
else
	SRC_URI="https://github.com/coin-or/ADOL-C/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/ADOL-C-releases-${PV}"
fi

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/2"
IUSE="+boost mpi sparse"

RDEPEND="
	boost? ( dev-libs/boost:= )
	mpi? ( sys-cluster/ampi:0= )
	sparse? ( sci-libs/colpack:0= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/${PN}-2.5.0-no-colpack.patch
	"${WORKDIR}"/${PN}-2.5.0-pkgconfig-no-ldflags.patch
	"${WORKDIR}"/${PN}-2.6.2-dash.patch
)

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Can drop CONFIG_SHELL once fixed up dash/bashisms patch
	CONFIG_SHELL="${BROOT}/bin/bash" econf \
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
