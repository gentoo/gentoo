# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bsdmk freebsd pam multilib multibuild multilib-build toolchain-funcs

DESCRIPTION="FreeBSD libexec things"
SLOT="0"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

EXTRACTONLY="
	libexec/
	usr.bin/
	bin/
	contrib/hyperv/
	lib/
	etc/
	usr.sbin/
"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*
	>=sys-freebsd/freebsd-lib-9.1-r11[${MULTILIB_USEDEP}]
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-sources-${RV}*"
RDEPEND="${RDEPEND}
	xinetd? ( sys-apps/xinetd )"

S="${WORKDIR}/libexec"

# Remove sendmail, tcp_wrapper and other useless stuff
REMOVE_SUBDIRS="smrsh mail.local tcpd telnetd rshd rlogind ftpd"

IUSE="pam ssl kerberos ipv6 nis xinetd"

PATCHES=( "${FILESDIR}/${PN}-9.2-no_ld32.patch"
	"${FILESDIR}/${PN}-10.2-atf-check.patch" )

pkg_setup() {
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6= WITHOUT_INET6_SUPPORT= "
	use kerberos || mymakeopts="${mymakeopts} WITHOUT_KERBEROS_SUPPORT= "
	use nis || mymakeopts="${mymakeopts} WITHOUT_NIS= "
	use pam || mymakeopts="${mymakeopts} WITHOUT_PAM_SUPPORT= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "

	mymakeopts="${mymakeopts} WITHOUT_SENDMAIL= WITHOUT_PF= WITHOUT_RCMDS= "
}

src_prepare() {
	# gcc-5.0 or later, Workaround for critical issue. bug 573358.
	[[ "$(gcc-major-version)" -ge 5 ]] && replace-flags -O? -O1

	if [[ ! -e "${WORKDIR}/include" ]]; then
		ln -s /usr/include "${WORKDIR}/include" || die "Symlinking /usr/include.."
	fi
	# allow upgrade directly from 9.x to 10.2.
	if has_version "<sys-freebsd/freebsd-lib-${RV}"; then
		# taken from sys/sys/elf_common.h
		echo "#define DF_1_INTERPOSE 0x00000400" >> "${S}"/rtld-elf/rtld.h
		echo "#define STT_GNU_IFUNC 10" >> "${S}"/rtld-elf/rtld.h
		echo "#define R_386_IRELATIVE 42" >> "${S}"/rtld-elf/rtld.h
		echo "#define PT_GNU_RELRO 0x6474e552" >> "${S}"/rtld-elf/rtld.h
		echo "#define DF_1_NODEFLIB 0x00000800" >> "${S}"/rtld-elf/rtld.h
		# taken from sys/sys/fcntl.h
		echo "#define F_DUPFD_CLOEXEC 17" >> "${S}"/rtld-elf/rtld.h
		# taken from sys/sys/cdefs.h
		echo '#define __compiler_membar()  __asm __volatile(" " : : : "memory")' >> "${S}"/rtld-elf/rtld.h
		# taken from sys/sys/mman.h
		echo '#define MAP_ALIGNED(n) ((n) << MAP_ALIGNMENT_SHIFT)' >> "${S}"/rtld-elf/rtld.h
		echo '#define MAP_ALIGNMENT_SHIFT 24' >> "${S}"/rtld-elf/rtld.h
		echo '#define MAP_ALIGNMENT_MASK MAP_ALIGNED(0xff)' >> "${S}"/rtld-elf/rtld.h
		echo '#define MAP_ALIGNED_SUPER MAP_ALIGNED(1)' >> "${S}"/rtld-elf/rtld.h
	fi
}

setup_multilib_vars() {
	if ! multilib_is_native_abi ; then
		cd "${WORKDIR}/libexec/rtld-elf" || die
		export mymakeopts="${mymakeopts} PROG=ld-elf32.so.1"
	else
		cd "${S}" || die
	fi
	"$@"
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
	multibuild_foreach_variant freebsd_multilib_multibuild_wrapper setup_multilib_vars freebsd_src_compile
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abis) )
	multibuild_foreach_variant freebsd_multilib_multibuild_wrapper setup_multilib_vars freebsd_src_install

	insinto /etc
	doins "${WORKDIR}/etc/gettytab"
	newinitd "${FILESDIR}/bootpd.initd" bootpd
	newconfd "${FILESDIR}/bootpd.confd" bootpd

	if use xinetd; then
		for rpcd in rstatd rusersd walld rquotad sprayd; do
			insinto /etc/xinetd.d
			newins "${FILESDIR}/${rpcd}.xinetd" ${rpcd}
		done
	fi
}
