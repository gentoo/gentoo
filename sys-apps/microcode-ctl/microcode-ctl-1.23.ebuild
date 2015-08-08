# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit linux-info toolchain-funcs

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Intel processor microcode update utility"
HOMEPAGE="https://fedorahosted.org/microcode_ctl/"
SRC_URI="https://fedorahosted.org/released/${PN/-/_}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="selinux"

DEPEND=""
RDEPEND=">=sys-apps/microcode-data-20090330
	selinux? ( sec-policy/selinux-cpucontrol )"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}"
}

src_install() {
	dosbin microcode_ctl
	doman microcode_ctl.8
	dodoc Changelog README

	newinitd "${FILESDIR}"/microcode_ctl.rc-r1 microcode_ctl
	newconfd "${FILESDIR}"/microcode_ctl.conf.d microcode_ctl
}

pkg_postinst() {
	# Just a friendly warning
	if ! linux_config_exists || ! linux_chkconfig_present MICROCODE; then
		echo
		ewarn "Your kernel must include microcode update support."
		ewarn "  Processor type and features --->"
		ewarn "  <*> /dev/cpu/microcode - microcode support"
		echo
	fi
	elog "Microcode updates will be lost at every reboot."
	elog "You can use the init.d script to update at boot time."
}
