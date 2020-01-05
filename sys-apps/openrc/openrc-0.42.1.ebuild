# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic pam toolchain-funcs usr-ldscript

DESCRIPTION="OpenRC manages the services, startup and shutdown of a host"
HOMEPAGE="https://github.com/openrc/openrc/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/OpenRC/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sh ~sparc x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="audit bash debug ncurses pam newnet prefix +netifrc selinux static-libs
	sysv-utils unicode"

COMMON_DEPEND="
	ncurses? ( sys-libs/ncurses:0= )
	pam? (
		sys-auth/pambase
		sys-libs/pam
	)
	audit? ( sys-process/audit )
	sys-process/psmisc
	!<sys-process/procps-3.3.9-r2
	selinux? (
		sys-apps/policycoreutils
		>=sys-libs/libselinux-2.6
	)
	!<sys-apps/baselayout-2.1-r1
	!<sys-fs/udev-init-scripts-27"
DEPEND="${COMMON_DEPEND}
	virtual/os-headers
	ncurses? ( virtual/pkgconfig )"
RDEPEND="${COMMON_DEPEND}
	bash? ( app-shells/bash )
	!prefix? (
		sysv-utils? ( !sys-apps/sysvinit )
		!sysv-utils? ( >=sys-apps/sysvinit-2.86-r6[selinux?] )
		virtual/tmpfiles
	)
	selinux? (
		>=sec-policy/selinux-base-policy-2.20170204-r4
		>=sec-policy/selinux-openrc-2.20170204-r4
	)
	!<app-shells/gentoo-bashcomp-20180302
	!<app-shells/gentoo-zsh-completions-20180228
"

PDEPEND="netifrc? ( net-misc/netifrc )"

src_prepare() {
	default
	if [[ ${PV} == "9999" ]] ; then
		local ver="git-${EGIT_VERSION:0:6}"
		sed -i "/^GITVER[[:space:]]*=/s:=.*:=${ver}:" mk/gitver.mk || die
	fi
}

src_compile() {
	unset LIBDIR #266688

	MAKE_ARGS="${MAKE_ARGS}
		LIBNAME=$(get_libdir)
		LIBEXECDIR=${EPREFIX}/lib/rc
		MKBASHCOMP=yes
		MKNET=$(usex newnet)
		MKSELINUX=$(usex selinux)
		MKSYSVINIT=$(usex sysv-utils)
		MKAUDIT=$(usex audit)
		MKPAM=$(usev pam)
		MKSTATICLIBS=$(usex static-libs)
		MKZSHCOMP=yes
		SH=$(usex bash /bin/bash /bin/sh)"

	local brand="Unknown"
	MAKE_ARGS="${MAKE_ARGS} OS=Linux"
	brand="Linux"
	export BRANDING="Gentoo ${brand}"
	use prefix && MAKE_ARGS="${MAKE_ARGS} MKPREFIX=yes PREFIX=${EPREFIX}"
	export DEBUG=$(usev debug)
	export MKTERMCAP=$(usev ncurses)

	tc-export CC AR RANLIB
	emake ${MAKE_ARGS}
}

# set_config <file> <option name> <yes value> <no value> test
# a value of "#" will just comment out the option
set_config() {
	local file="${ED}/$1" var=$2 val com
	eval "${@:5}" && val=$3 || val=$4
	[[ ${val} == "#" ]] && com="#" && val='\2'
	sed -i -r -e "/^#?${var}=/{s:=([\"'])?([^ ]*)\1?:=\1${val}\1:;s:^#?:${com}:}" "${file}"
}

set_config_yes_no() {
	set_config "$1" "$2" YES NO "${@:3}"
}

src_install() {
	emake ${MAKE_ARGS} DESTDIR="${D}" install

	# move the shared libs back to /usr so ldscript can install
	# more of a minimal set of files
	# disabled for now due to #270646
	#mv "${ED}"/$(get_libdir)/lib{einfo,rc}* "${ED}"/usr/$(get_libdir)/ || die
	#gen_usr_ldscript -a einfo rc
	gen_usr_ldscript libeinfo.so
	gen_usr_ldscript librc.so

	keepdir /lib/rc/tmp

	# Setup unicode defaults for silly unicode users
	set_config_yes_no /etc/rc.conf unicode use unicode

	# Cater to the norm
	set_config_yes_no /etc/conf.d/keymaps windowkeys '(' use x86 '||' use amd64 ')'

	# On HPPA, do not run consolefont by default (bug #222889)
	if use hppa; then
		rm -f "${ED}"/etc/runlevels/boot/consolefont
	fi

	# Support for logfile rotation
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openrc.logrotate openrc

	# install gentoo pam.d files
	newpamd "${FILESDIR}"/start-stop-daemon.pam start-stop-daemon
	newpamd "${FILESDIR}"/start-stop-daemon.pam supervise-daemon

	# install documentation
	dodoc ChangeLog *.md
	if use newnet; then
		dodoc README.newnet
	fi
}

pkg_preinst() {
	# avoid default thrashing in conf.d files when possible #295406
	if [[ -e "${EROOT}"/etc/conf.d/hostname ]] ; then
		(
		unset hostname HOSTNAME
		source "${EROOT}"/etc/conf.d/hostname
		: ${hostname:=${HOSTNAME}}
		[[ -n ${hostname} ]] && set_config /etc/conf.d/hostname hostname "${hostname}"
		)
	fi

	# set default interactive shell to sulogin if it exists
	set_config /etc/rc.conf rc_shell /sbin/sulogin "#" test -e /sbin/sulogin
	return 0
}

pkg_postinst() {
	if use hppa; then
		elog "Setting the console font does not work on all HPPA consoles."
		elog "You can still enable it by running:"
		elog "# rc-update add consolefont boot"
	fi

	# Added for 0.35.
	if [[ ! -h "${EROOT}"/lib ]]; then
		if [[ -d "${EROOT}/$(get_libdir)"/rc ]]; then
			cp -RPp "${EROOT}/$(get_libdir)/rc" "${EROOT}"/lib
		fi
	fi

	if ! use newnet && ! use netifrc; then
		ewarn "You have emerged OpenRc without network support. This"
		ewarn "means you need to SET UP a network manager such as"
		ewarn "	net-misc/netifrc, net-misc/dhcpcd, net-misc/wicd,"
		ewarn "net-misc/NetworkManager, or net-vpn/badvpn."
		ewarn "Or, you have the option of emerging openrc with the newnet"
		ewarn "use flag and configuring /etc/conf.d/network and"
		ewarn "/etc/conf.d/staticroute if you only use static interfaces."
		ewarn
	fi

	if use newnet && [ ! -e "${EROOT}"/etc/runlevels/boot/network ]; then
		ewarn "Please add the network service to your boot runlevel"
		ewarn "as soon as possible. Not doing so could leave you with a system"
		ewarn "without networking."
		ewarn
	fi
}
