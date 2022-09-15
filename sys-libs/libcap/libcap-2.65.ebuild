# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs pam usr-ldscript

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/libcap/libcap.git"
else
	SRC_URI="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${P}.tar.xz"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="https://sites.google.com/site/fullycapable/"

# it's available under either of the licenses
LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
IUSE="pam static-libs tools"

# While the build system optionally uses gperf, we don't DEPEND on it because
# the build automatically falls back when it's unavailable.  #604802
PDEPEND="pam? ( sys-libs/pam[${MULTILIB_USEDEP}] )"
DEPEND="${PDEPEND}
	sys-kernel/linux-headers"
BDEPEND="
	sys-apps/diffutils
	tools? ( dev-lang/go )"

QA_FLAGS_IGNORED="sbin/captree" # go binaries don't use LDFLAGS

PATCHES=(
	"${FILESDIR}"/${PN}-2.62-ignore-RAISE_SETFCAP-install-failures.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

run_emake() {
	local args=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		OBJCOPY="$(tc-getOBJCOPY)"
		RANLIB="$(tc-getRANLIB)"
		exec_prefix="${EPREFIX}"
		lib_prefix="${EPREFIX}/usr"
		lib="$(get_libdir)"
		prefix="${EPREFIX}/usr"
		PAM_CAP="$(usex pam yes no)"
		DYNAMIC=yes
		GOLANG="$(multilib_native_usex tools yes no)"
	)
	emake "${args[@]}" "$@"
}

src_configure() {
	tc-export_build_env BUILD_CC
	multilib-minimal_src_configure
}

multilib_src_compile() {
	run_emake
}

multilib_src_test() {
	run_emake test
}

multilib_src_install() {
	# no configure, needs explicit install line #444724#c3
	run_emake DESTDIR="${D}" install

	gen_usr_ldscript -a cap
	gen_usr_ldscript -a psx
	if ! use static-libs ; then
		rm "${ED}"/usr/$(get_libdir)/lib{cap,psx}.a || die
	fi

	# install pam plugins ourselves
	rm -rf "${ED}"/usr/$(get_libdir)/security || die

	if use pam ; then
		dopammod pam_cap/pam_cap.so
		dopamsecurity '' pam_cap/capability.conf
	fi
}

multilib_src_install_all() {
	dodoc CHANGELOG README doc/capability.notes
}
