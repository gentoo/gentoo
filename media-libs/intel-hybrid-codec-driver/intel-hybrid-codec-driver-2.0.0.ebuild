# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_64 )
EGIT_COMMIT="edead0c17e2818bc0fee0ea644f85ab81bbe6f7a"

inherit autotools multilib-minimal

DESCRIPTION="Libva support for older hardware accelerated encode/decode on Haswell and newer"
HOMEPAGE="https://github.com/intel/intel-hybrid-driver"
SRC_URI="https://github.com/intel/intel-hybrid-driver/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/intel-hybrid-driver-${EGIT_COMMIT}"

KEYWORDS="~amd64 ~amd64-linux"
LICENSE="MIT"
SLOT="0"
IUSE="wayland X"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=x11-libs/cmrt-1.0.6
	>=x11-libs/libdrm-2.4.45
	>=media-libs/libva-1.0.16[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc10-fix.patch"
	"${FILESDIR}/${P}-vadriverinit-fix.patch"
	"${FILESDIR}/${P}-x11-fix.patch"
	"${FILESDIR}/${P}-nullptr-fix.patch"
	"${FILESDIR}/${P}-invalid-read-fix.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable wayland)
		$(use_enable X x11)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
