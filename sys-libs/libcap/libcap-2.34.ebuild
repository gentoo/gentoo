# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal toolchain-funcs pam usr-ldscript

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="https://sites.google.com/site/fullycapable/"
SRC_URI="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${P}.tar.xz"

# it's available under either of the licenses
LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="pam static-libs"

# While the build system optionally uses gperf, we don't DEPEND on it because
# the build automatically falls back when it's unavailable.  #604802
RDEPEND=">=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}]"
PDEPEND="pam? ( sys-libs/pam[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	${PDEPEND}
	sys-kernel/linux-headers"

# Requires test suite being run as root (via sudo)
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.34-build-system-fixes.patch
	"${FILESDIR}"/${PN}-2.28-no_perl.patch
	"${FILESDIR}"/${PN}-2.25-ignore-RAISE_SETFCAP-install-failures.patch
	"${FILESDIR}"/${PN}-2.21-include.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

run_emake() {
	local args=(
		exec_prefix="${EPREFIX}"
		lib_prefix="${EPREFIX}/usr"
		lib="$(get_libdir)"
		prefix="${EPREFIX}/usr"
		PAM_CAP="$(usex pam yes no)"
		DYNAMIC=yes
		GOLANG=no
	)
	emake "${args[@]}" "$@"
}

multilib_src_compile() {
	tc-export AR CC RANLIB
	local BUILD_CC
	tc-export_build_env BUILD_CC

	run_emake
}

multilib_src_install() {
	# no configure, needs explicit install line #444724#c3
	run_emake DESTDIR="${D}" install

	gen_usr_ldscript -a cap
	if ! use static-libs ; then
		# Don't remove libpsx.a!
		# See https://bugs.gentoo.org/703912
		rm "${ED}"/usr/$(get_libdir)/libcap.a || die
	fi

	if [[ -d "${ED}"/usr/$(get_libdir)/security ]] ; then
		rm -r "${ED}"/usr/$(get_libdir)/security || die
	fi

	if use pam; then
		dopammod pam_cap/pam_cap.so
		dopamsecurity '' pam_cap/capability.conf
	fi
}

multilib_src_install_all() {
	dodoc CHANGELOG README doc/capability.notes
}
