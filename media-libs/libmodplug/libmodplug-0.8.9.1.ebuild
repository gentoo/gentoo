# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PVR="${PV}.r461"

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Library for playing MOD-like music files"
HOMEPAGE="https://modplug-xmms.sourceforge.net/"
SRC_URI="https://github.com/ShiftMediaProject/modplug/archive/refs/tags/${MY_PVR}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/modplug-${MY_PVR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.9.1-timidity.patch"
	"${FILESDIR}/${PN}-0.8.9.0-no-fast-math.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/921707
	#
	# Upstream is dead for 2 years. Both of them -- the one in SRC_URI and the
	# one in metadata.xml. Where to report a bug *to*, even? Answer: neither. :(
	filter-lto

	ECONF_SOURCE=${S} econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
