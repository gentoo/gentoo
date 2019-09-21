# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools multilib-minimal

DESCRIPTION="Public client interface for NIS(YP) and NIS+ in a IPv6 ready version"
HOMEPAGE="https://github.com/thkukuk/libnsl"
SRC_URI="https://github.com/thkukuk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/2"
LICENSE="LGPL-2.1+"

# Stabilize together with glibc-2.26!
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux"

IUSE=""

DEPEND="
	>=net-libs/libtirpc-1.0.2-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	!<sys-libs/glibc-2.26
"

src_prepare(){
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
	)
	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
