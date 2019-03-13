# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs eutils git-r3

MYPN=ADOL-C

DESCRIPTION="Automatic differentiation system for C/C++"
HOMEPAGE="https://projects.coin-or.org/ADOL-C/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/adol-c/adol-c.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MYPN}-${PV}"
fi

LICENSE="|| ( EPL-1.0 GPL-2 )"
SLOT="0/2"
IUSE="+boost mpi sparse static-libs"

RDEPEND="
	boost? ( dev-libs/boost:0= )
	mpi? ( sys-cluster/ampi:0= )
	sparse? ( sci-libs/colpack:0= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-no-colpack.patch
	"${FILESDIR}"/${PN}-2.5.0-pkgconfig-no-ldflags.patch
	"${FILESDIR}"/${PN}-2.6.2-dash.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-advanced-branching \
		--enable-atrig-erf \
		$(use_enable mpi ampi) \
		$(use_enable sparse) \
		$(use_enable static-libs static) \
		$(use_with boost) \
		$(use_with sparse colpack "${EPREFIX}"/usr)
}

src_test() {
	emake test
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
}
