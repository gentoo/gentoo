# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Library to provide useful functions commonly found on BSD systems"
HOMEPAGE="https://libbsd.freedesktop.org/wiki/ https://gitlab.freedesktop.org/libbsd/libbsd"
SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="BSD BSD-2 BSD-4 ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-crypt/libmd[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.17
"

pkg_setup() {
	local f="${EROOT}/usr/$(get_libdir)/${PN}.a"
	if ! has_version ${CATEGORY}/${PN}; then
		if [[ -e ${f} ]]; then
			eerror "${m}"
			die "You need to remove ${f} by hand or re-emerge sys-libs/glibc first."
		fi
	fi
}

multilib_src_configure() {
	# The build system will install libbsd-ctor.a despite of USE="-static-libs"
	# which is correct, see:
	# https://gitlab.freedesktop.org/libbsd/libbsd/commit/c5b959028734ca2281250c85773d9b5e1d259bc8
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -type f -name "*.la" -delete || die
}
