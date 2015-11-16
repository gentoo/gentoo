# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# See `man savedconfig.eclass` for info on how to use USE=savedconfig.

EAPI="4"
inherit eutils flag-o-matic savedconfig toolchain-funcs multilib

DESCRIPTION="Utilities for rescue and embedded systems"
HOMEPAGE="http://www.busybox.net/"
if [[ ${PV} == "9999" ]] ; then
	MY_P=${PN}
	EGIT_REPO_URI="git://busybox.net/busybox.git"
	inherit git-2
else
	MY_P=${PN}-${PV/_/-}
	SRC_URI="http://www.busybox.net/downloads/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
fi

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
IUSE="debug ipv6 livecd make-symlinks math mdev pam selinux sep-usr static syslog systemd"
RESTRICT="test"

COMMON_DEPEND="!static? ( selinux? ( sys-libs/libselinux ) )
	pam? ( sys-libs/pam )"
DEPEND="${COMMON_DEPEND}
	static? ( selinux? ( sys-libs/libselinux[static-libs(+)] ) )
	>=sys-kernel/linux-headers-2.6.39"
RDEPEND="${COMMON_DEPEND}
	mdev? ( !<sys-apps/openrc-0.13 )"

S=${WORKDIR}/${MY_P}

busybox_config_option() {
	local flag=$1 ; shift
	if [[ ${flag} != [yn] ]] ; then
		busybox_config_option $(usex ${flag} y n) "$@"
		return
	fi
	while [[ $# -gt 0 ]] ; do
		if [[ ${flag} == "y" ]] ; then
			sed -i -e "s:.*\<CONFIG_$1\>.*set:CONFIG_$1=y:g" .config
		else
			sed -i -e "s:CONFIG_$1=y:# CONFIG_$1 is not set:g" .config
		fi
		einfo $(grep "CONFIG_$1[= ]" .config || echo Could not find CONFIG_$1 ...)
		shift
	done
}

busybox_config_enabled() {
	local val=$(sed -n "/^CONFIG_$1=/s:^[^=]*=::p" .config)
	case ${val} in
	"") return 1 ;;
	y)  return 0 ;;
	*)  echo "${val}" | sed -r 's:^"(.*)"$:\1:' ;;
	esac
}

src_prepare() {
	unset KBUILD_OUTPUT #88088
	append-flags -fno-strict-aliasing #310413
	use ppc64 && append-flags -mminimal-toc #130943

	# patches go here!
	epatch "${FILESDIR}"/${PN}-1.19.0-bb.patch
	epatch "${FILESDIR}"/${P}-*.patch
	cp "${FILESDIR}"/ginit.c init/ || die

	# flag cleanup
	sed -i -r \
		-e 's:[[:space:]]?-(Werror|Os|falign-(functions|jumps|loops|labels)=1|fomit-frame-pointer)\>::g' \
		Makefile.flags || die
	#sed -i '/bbsh/s:^//::' include/applets.h
	sed -i '/^#error Aborting compilation./d' applets/applets.c || die
	use elibc_glibc && sed -i 's:-Wl,--gc-sections::' Makefile
	sed -i \
		-e "/^CROSS_COMPILE/s:=.*:= ${CHOST}-:" \
		-e "/^AR\>/s:=.*:= $(tc-getAR):" \
		-e "/^CC\>/s:=.*:= $(tc-getCC):" \
		-e "/^HOSTCC/s:=.*:= $(tc-getBUILD_CC):" \
		-e "/^PKG_CONFIG\>/s:=.*:= $(tc-getPKG_CONFIG):" \
		Makefile || die
	sed -i \
		-e 's:-static-libgcc::' \
		Makefile.flags || die
}

src_configure() {
	# check for a busybox config before making one of our own.
	# if one exist lets return and use it.

	restore_config .config
	if [ -f .config ]; then
		yes "" | emake -j1 -s oldconfig >/dev/null
		return 0
	else
		ewarn "Could not locate user configfile, so we will save a default one"
	fi

	# setup the config file
	emake -j1 -s allyesconfig >/dev/null
	# nommu forces a bunch of things off which we want on #387555
	busybox_config_option n NOMMU
	sed -i '/^#/d' .config
	yes "" | emake -j1 -s oldconfig >/dev/null

	# now turn off stuff we really don't want
	busybox_config_option n DMALLOC
	busybox_config_option n FEATURE_SUID_CONFIG
	busybox_config_option n BUILD_AT_ONCE
	busybox_config_option n BUILD_LIBBUSYBOX
	busybox_config_option n FEATURE_CLEAN_UP
	busybox_config_option n MONOTONIC_SYSCALL
	busybox_config_option n USE_PORTABLE_CODE
	busybox_config_option n WERROR

	# If these are not set and we are using a uclibc/busybox setup
	# all calls to system() will fail.
	busybox_config_option y ASH
	busybox_config_option n HUSH

	# disable ipv6 applets
	if ! use ipv6; then
		busybox_config_option n FEATURE_IPV6
		busybox_config_option n TRACEROUTE6
		busybox_config_option n PING6
		busybox_config_option n UDHCPC6
	fi

	if use static && use pam ; then
		ewarn "You cannot have USE='static pam'.  Assuming static is more important."
	fi
	busybox_config_option $(usex static n pam) PAM
	busybox_config_option static STATIC
	busybox_config_option syslog {K,SYS}LOGD LOGGER
	busybox_config_option systemd FEATURE_SYSTEMD
	busybox_config_option math FEATURE_AWK_LIBM

	# all the debug options are compiler related, so punt them
	busybox_config_option n DEBUG
	busybox_config_option y NO_DEBUG_LIB
	busybox_config_option n DMALLOC
	busybox_config_option n EFENCE
	busybox_config_option $(usex debug y n) TFTP_DEBUG

	busybox_config_option selinux SELINUX

	# this opt only controls mounting with <linux-2.6.23
	busybox_config_option n FEATURE_MOUNT_NFS

	# default a bunch of uncommon options to off
	local opt
	for opt in \
		ADD_SHELL \
		BEEP BOOTCHARTD \
		CRONTAB \
		DC DEVFSD DNSD DPKG{,_DEB} \
		FAKEIDENTD FBSPLASH FOLD FSCK_MINIX FTP{GET,PUT} \
		FEATURE_DEVFS \
		HOSTID HUSH \
		INETD INOTIFYD IPCALC \
		LOCALE_SUPPORT LOGNAME LPD \
		MAKEMIME MKFS_MINIX MSH \
		OD \
		RDEV READPROFILE REFORMIME REMOVE_SHELL RFKILL RUN_PARTS RUNSV{,DIR} \
		SLATTACH SMEMCAP SULOGIN SV{,LOGD} \
		TASKSET TCPSVD \
		RPM RPM2CPIO \
		UDPSVD UUDECODE UUENCODE
	do
		busybox_config_option n ${opt}
	done

	emake -j1 oldconfig > /dev/null
}

src_compile() {
	unset KBUILD_OUTPUT #88088
	export SKIP_STRIP=y

	emake V=1 busybox
}

src_install() {
	unset KBUILD_OUTPUT #88088
	save_config .config

	into /
	dodir /bin
	if use sep-usr ; then
		# install /ginit to take care of mounting stuff
		exeinto /
		newexe busybox_unstripped ginit
		dosym /ginit /bin/bb
		dosym bb /bin/busybox
	else
		newbin busybox_unstripped busybox
		dosym busybox /bin/bb
	fi
	if use mdev ; then
		dodir /$(get_libdir)/mdev/
		use make-symlinks || dosym /bin/bb /sbin/mdev
		cp "${S}"/examples/mdev_fat.conf "${ED}"/etc/mdev.conf

		exeinto /$(get_libdir)/mdev/
		doexe "${FILESDIR}"/mdev/*

		newinitd "${FILESDIR}"/mdev.initd mdev
	fi
	if use livecd ; then
		dosym busybox /bin/vi
	fi

	# add busybox daemon's, bug #444718
	if busybox_config_enabled FEATURE_NTPD_SERVER; then
		newconfd "${FILESDIR}/ntpd.confd" "busybox-ntpd"
		newinitd "${FILESDIR}/ntpd.initd" "busybox-ntpd"
	fi
	if busybox_config_enabled SYSLOGD; then
		newconfd "${FILESDIR}/syslogd.confd" "busybox-syslogd"
		newinitd "${FILESDIR}/syslogd.initd" "busybox-syslogd"
	fi
	if busybox_config_enabled KLOGD; then
		newconfd "${FILESDIR}/klogd.confd" "busybox-klogd"
		newinitd "${FILESDIR}/klogd.initd" "busybox-klogd"
	fi
	if busybox_config_enabled WATCHDOG; then
		newconfd "${FILESDIR}/watchdog.confd" "busybox-watchdog"
		newinitd "${FILESDIR}/watchdog.initd" "busybox-watchdog"
	fi
	if busybox_config_enabled UDHCPC; then
		local path=$(busybox_config_enabled UDHCPC_DEFAULT_SCRIPT)
		exeinto "${path%/*}"
		newexe examples/udhcp/simple.script "${path##*/}"
	fi
	if busybox_config_enabled UDHCPD; then
		insinto /etc
		doins examples/udhcp/udhcpd.conf
	fi

	# bundle up the symlink files for use later
	emake DESTDIR="${ED}" install
	rm _install/bin/busybox
	# for compatibility, provide /usr/bin/env
	mkdir -p _install/usr/bin
	ln -s /bin/env _install/usr/bin/env
	tar cf busybox-links.tar -C _install . || : #;die
	insinto /usr/share/${PN}
	use make-symlinks && doins busybox-links.tar

	dodoc AUTHORS README TODO

	cd docs
	docinto txt
	dodoc *.txt
	docinto pod
	dodoc *.pod
	dohtml *.html

	cd ../examples
	docinto examples
	dodoc inittab depmod.pl *.conf *.script undeb unrpm
}

pkg_preinst() {
	if use make-symlinks && [[ ! ${VERY_BRAVE_OR_VERY_DUMB} == "yes" ]] && [[ ${ROOT} == "/" ]] ; then
		ewarn "setting USE=make-symlinks and emerging to / is very dangerous."
		ewarn "it WILL overwrite lots of system programs like: ls bash awk grep (bug 60805 for full list)."
		ewarn "If you are creating a binary only and not merging this is probably ok."
		ewarn "set env VERY_BRAVE_OR_VERY_DUMB=yes if this is really what you want."
		die "silly options will destroy your system"
	fi

	if use make-symlinks ; then
		mv "${ED}"/usr/share/${PN}/busybox-links.tar "${T}"/ || die
	fi
}

pkg_postinst() {
	savedconfig_pkg_postinst

	if use make-symlinks ; then
		cd "${T}" || die
		mkdir _install
		tar xf busybox-links.tar -C _install || die
		cp -vpPR _install/* "${ROOT}"/ || die "copying links for ${x} failed"
	fi

	if use sep-usr ; then
		elog "In order to use the sep-usr support, you have to update your"
		elog "kernel command line.  Add the option:"
		elog "     init=/ginit"
		elog "To launch a different init than /sbin/init, use:"
		elog "     init=/ginit /sbin/yourinit"
		elog "To get a rescue shell, you may boot with:"
		elog "     init=/ginit bb"
	fi
}
