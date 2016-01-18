# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://people.freedesktop.org/~airlied/virglrenderer"
	inherit git-2
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"

RDEPEND=">=x11-libs/libdrm-2.4.50
	media-libs/libepoxy"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	>=x11-misc/util-macros-1.8
	test? ( >=dev-libs/check-0.9.4 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libdrm.patch #571124
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
