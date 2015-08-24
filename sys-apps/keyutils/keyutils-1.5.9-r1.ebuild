# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib eutils toolchain-funcs linux-info multilib-minimal

DESCRIPTION="Linux Key Management Utilities"
HOMEPAGE="https://people.redhat.com/dhowells/keyutils/"
SRC_URI="https://people.redhat.com/dhowells/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="!prefix? ( >=sys-kernel/linux-headers-2.6.11 )"

pkg_setup() {
	CONFIG_CHECK="~KEYS"
	use test && CONFIG_CHECK="${CONFIG_CHECK} ~KEYS_DEBUG_PROC_KEYS"
	ERROR_KEYS="You must have CONFIG_KEYS to use this package!"
	ERROR_KEYS_DEBUG_PROC_KEYS="You must have CONFIG_KEYS_DEBUG_PROC_KEYS to run the package testsuite!"
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5.5-makefile-fixup.patch

	# The lsb check is useless, so avoid spurious command not found messages.
	sed -i -e 's,lsb_release,:,' tests/prepare.inc.sh || die
	# All the test files are bash, but try to execute via `sh`.
	sed -i -r \
		-e 's:([[:space:]])sh([[:space:]]):\1bash\2:' \
		tests/{Makefile*,*.sh} || die
	find tests/ -name '*.sh' -exec sed -i '1s:/sh$:/bash:' {} +
	# Some tests call the kernel which calls userspace, but that will
	# run the install keyutils rather than the locally compiled one,
	# so disable round trip tests.
	rm -rf tests/keyctl/requesting/{bad-args,piped,valid}

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC
	tc-export AR
	sed -i \
		-e '1iRPATH=' \
		-e '/^C.*FLAGS/s|:=|+=|' \
		-e 's:-Werror::' \
		-e '/^BUILDFOR/s:=.*:=:' \
		-e "/^LIBDIR/s:=.*:= /usr/$(get_libdir):" \
		-e '/^USRLIBDIR/s:=.*:=$(LIBDIR):' \
		-e "s: /: ${EPREFIX}/:g" \
		Makefile || die

	emake
}

multilib_src_test() {
	# Execute the locally compiled code rather than the
	# older versions already installed in the system.
	LD_LIBRARY_PATH=${BUILD_DIR} \
	PATH="${BUILD_DIR}:${PATH}" \
	emake test
}

multilib_src_install() {
	default
	multilib_is_native_abi && gen_usr_ldscript -a keyutils
}

multilib_src_install_all() {
	dodoc README
}
