# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs linux-info multilib-minimal

DESCRIPTION="Linux Key Management Utilities"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1.9"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="!prefix? ( >=sys-kernel/linux-headers-2.6.11 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6-makefile-fixup.patch
	"${FILESDIR}"/${PN}-1.5.10-disable-tests.patch #519062 #522050
	"${FILESDIR}"/${PN}-1.6.3-fix-rpmspec-check.patch
	"${FILESDIR}"/${PN}-1.6.3-symbols.patch
	"${FILESDIR}"/${P}-tests.patch
	"${FILESDIR}"/${PN}-1.6.3-EDQUOT-tests.patch
)

pkg_setup() {
	# To prevent a failure in test phase and false positive bug reports
	# we are enforcing the following options because testsuite expects
	# that these options are available. I.e. testsuite only decides based
	# on kernel version which tests will be called, no feature checking.
	if use test ; then
		CONFIG_CHECK="KEYS"
		ERROR_KEYS="You must have CONFIG_KEYS to run the package testsuite!"

		if kernel_is -ge 2 6 10 && kernel_is -lt 4 0 0 ; then
			CONFIG_CHECK="${CONFIG_CHECK} KEYS_DEBUG_PROC_KEYS"
			ERROR_KEYS_DEBUG_PROC_KEYS="You must have CONFIG_KEYS_DEBUG_PROC_KEYS to run the package testsuite!"
		fi

		if kernel_is -ge 4 7 ; then
			CONFIG_CHECK="${CONFIG_CHECK} KEY_DH_OPERATIONS"
			ERROR_KEY_DH_OPERATIONS="You must have CONFIG_KEY_DH_OPERATIONS to run the package testsuite!"
		fi
	else
		CONFIG_CHECK="~KEYS"
		ERROR_KEYS="You will be unable to use this package on this system because CONFIG_KEYS is not set!"

		if kernel_is -ge 4 7 ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~KEY_DH_OPERATIONS"
			ERROR_KEY_DH_OPERATIONS="You will be unable to use Diffie-Hellman on this system because CONFIG_KEY_DH_OPERATIONS is not set!"
		fi
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default

	# The lsb check is useless, so avoid spurious command not found messages.
	sed -i -e 's,lsb_release,:,' tests/prepare.inc.sh || die
	# Some tests call the kernel which calls userspace, but that will
	# run the install keyutils rather than the locally compiled one,
	# so disable round trip tests.
	rm -rf tests/keyctl/requesting/{bad-args,piped,valid}

	multilib_copy_sources
}

mymake() {
	local args=(
		PREFIX="${EPREFIX}/usr"
		ETCDIR="${EPREFIX}/etc"
		BINDIR="${EPREFIX}/bin"
		SBINDIR="${EPREFIX}/sbin"
		SHAREDIR="${EPREFIX}/usr/share/keyutils"
		MANDIR="${EPREFIX}/usr/share/man"
		INCLUDEDIR="${EPREFIX}/usr/include"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		USRLIBDIR="${EPREFIX}/usr/$(get_libdir)"
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		RPATH=$(usex static -static '')
		BUILDFOR=
		NO_ARLIB="${NO_ARLIB}"
	)
	if use static; then
		args+=( LIB_DEPENDENCY='$(ARLIB)' )
	fi
	emake "${args[@]}" "$@"
}

multilib_src_compile() {
	local NO_ARLIB
	if use static; then
		NO_ARLIB=0
	else
		NO_ARLIB=$(usex static-libs 0 1)
	fi
	tc-export AR CC CXX
	mymake
}

multilib_src_test() {
	# Execute the locally compiled code rather than the
	# older versions already installed in the system.
	LD_LIBRARY_PATH=${BUILD_DIR} \
	PATH="${BUILD_DIR}:${PATH}" \
	mymake test
}

multilib_src_install() {
	# Possibly undo the setting for USE=static (see src_compile).
	local NO_ARLIB=$(usex static-libs 0 1)
	mymake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc README
}
