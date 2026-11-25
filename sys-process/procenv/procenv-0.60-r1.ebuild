# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="command-line utility to show process environment"
HOMEPAGE="https://github.com/jamesodhunt/procenv"
SRC_URI="https://github.com/jamesodhunt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="apparmor caps numa selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	caps? ( sys-libs/libcap )
	numa? ( sys-process/numactl )
	selinux? ( sys-libs/libselinux )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.60-fix-typo.patch
	"${FILESDIR}"/${PN}-0.60-no-werror.patch
	"${FILESDIR}"/${PN}-0.60-musl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC LD CPP
	export CPP="${CPP/-gcc -E/-cpp}"

	use apparmor || export ac_cv_search_aa_gettaskcon=no
	export ac_cv_header_sys_apparmor_h=$(usex apparmor)
	export ac_cv_header_sys_capability_h=$(usex caps)
	export ac_cv_header_numa_h=$(usex numa)
	use selinux || export ac_cv_search_getpidcon=no
	export ac_cv_header_selinux_selinux_h=$(usex selinux)

	default
}
