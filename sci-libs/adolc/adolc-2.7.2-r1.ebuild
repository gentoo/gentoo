# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/coin-or/ADOL-C"
else
	SRC_URI="
		https://github.com/coin-or/ADOL-C/archive/releases/${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-2.7.2-patches.tar.bz2
	"
	S="${WORKDIR}/ADOL-C-releases-${PV}"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ppc ppc64 ~riscv ~x86"
fi

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/$(ver_cut 1)"
IUSE="+boost mpi sparse"

RDEPEND="
	mpi? ( sys-cluster/ampi:0= )
	sparse? ( sci-libs/colpack )
"
DEPEND="${RDEPEND}
	boost? ( dev-libs/boost:= )
"

PATCHES=(
	"${WORKDIR}/${PN}-2.5.0-no-colpack.patch"
	"${WORKDIR}/${PN}-2.5.0-pkgconfig-no-ldflags.patch"
	"${WORKDIR}/${PN}-2.6.2-dash.patch"
	"${WORKDIR}/${P}-swig-python-configure.patch"
)

src_prepare() {
	sed \
		-e 's/${D\[@\]}/"${DIR[[@]]}"/g' \
		-i "${WORKDIR}/adolc-2.5.0-no-colpack.patch" || die

	default

	sed \
		-e 's/D\[\[/DIR[[/g' \
		-i "${S}/autoconf/colpack.m4" || die

	eautoreconf
}

src_configure() {
	# Disabling Python for now because swig build
	# needs work. Revisit with >=2.7.3.
	# https://bugs.gentoo.org/730750
	# https://github.com/coin-or/ADOL-C/issues/20
	# Can drop CONFIG_SHELL once fixed up dash/bashisms patch
	local myeconfargs=(
		--disable-python
		--disable-static
		--enable-advanced-branching
		--enable-atrig-erf
		$(use_enable mpi ampi)
		$(use_enable sparse)
		$(use_with boost)
		$(use_with sparse colpack "${EPREFIX}"/usr)
	)

	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myeconfargs[@]}"
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
