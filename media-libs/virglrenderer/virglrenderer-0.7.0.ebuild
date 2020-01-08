# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=">=x11-libs/libdrm-2.4.50
	media-libs/libepoxy"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	>=x11-misc/util-macros-1.8
	test? ( >=dev-libs/check-0.9.4 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-libdrm.patch
)

src_prepare() {
	default
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${ED}"/usr -name 'lib*.la' -delete
}
