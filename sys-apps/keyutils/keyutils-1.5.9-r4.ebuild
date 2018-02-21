# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib eutils toolchain-funcs linux-info multilib-minimal

DESCRIPTION="Linux Key Management Utilities"
HOMEPAGE="https://people.redhat.com/dhowells/keyutils/"
SRC_URI="https://people.redhat.com/dhowells/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static static-libs test"

RDEPEND=""
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
	epatch "${FILESDIR}"/${PN}-1.5.9-endian-check-{1,2}.patch #426424
	epatch "${FILESDIR}"/${PN}-1.5.9-disable-tests.patch #519062 #522050
	epatch "${FILESDIR}"/${PN}-1.5.9-header-extern-c.patch

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

	# Delete man pages that are included in the common package now. #612640
	rm man/*-keyring.7 man/keyrings.7 || die

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export AR CC
	sed -i \
		-e "1iRPATH = $(usex static -static '')" \
		-e '/^C.*FLAGS/s|:=|+=|' \
		-e 's:-Werror::' \
		-e '/^BUILDFOR/s:=.*:=:' \
		-e "/^LIBDIR/s:=.*:= /usr/$(get_libdir):" \
		-e '/^USRLIBDIR/s:=.*:=$(LIBDIR):' \
		-e "s: /: ${EPREFIX}/:g" \
		-e '/^NO_ARLIB/d' \
		Makefile || die

	# We need the static lib in order to statically link programs.
	if use static ; then
		export NO_ARLIB=0
		# Hack the progs to depend on the static lib instead.
		sed -i \
			-e '/^.*:.*[$](DEVELLIB)$/s:$(DEVELLIB):$(ARLIB):' \
			Makefile || die
	else
		export NO_ARLIB=$(usex static-libs 0 1)
	fi
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
	# Possibly undo the setting for USE=static (see src_compile).
	export NO_ARLIB=$(usex static-libs 0 1)

	default
	use static || gen_usr_ldscript -a keyutils
}

multilib_src_install_all() {
	dodoc README
}
