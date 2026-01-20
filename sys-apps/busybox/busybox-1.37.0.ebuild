# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See `man savedconfig.eclass` for info on how to use USE=savedconfig.

EAPI=8

inherit eapi9-ver flag-o-matic readme.gentoo-r1 savedconfig toolchain-funcs

DESCRIPTION="Utilities for rescue and embedded systems"
HOMEPAGE="https://www.busybox.net/"
if [[ ${PV} == "9999" ]] ; then
	MY_P="${P}"
	EGIT_REPO_URI="https://git.busybox.net/busybox"
	inherit git-r3
else
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="https://www.busybox.net/downloads/${MY_P}.tar.bz2"
	# unstable release - no keywords
	# KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
IUSE="debug livecd make-symlinks math mdev pam selinux sep-usr static syslog systemd"
REQUIRED_USE="pam? ( !static )"
RESTRICT="test"

# TODO: Could make pkgconfig conditional on selinux? bug #782829
RDEPEND="
	!static? (
		virtual/libc
		virtual/libcrypt:=
		selinux? ( sys-libs/libselinux )
	)
	pam? ( sys-libs/pam )
"
DEPEND="${RDEPEND}
	static? (
		virtual/libcrypt[static-libs]
		selinux? ( sys-libs/libselinux[static-libs(+)] )
	)
	sys-kernel/linux-headers"
BDEPEND="
	virtual/pkgconfig
	make-symlinks? ( >=sys-apps/coreutils-9.2 )
"

DISABLE_AUTOFORMATTING=yes
DOC_CONTENTS='
If you want a smaller executable, add `-Oz` to your busybox `CFLAGS`.'

busybox_config_option() {
	local flag=$1 ; shift
	if [[ ${flag} != [yn] && ${flag} != \"* ]] ; then
		busybox_config_option $(usex ${flag} y n) "$@"
		return
	fi
	local expr
	while [[ $# -gt 0 ]] ; do
		case ${flag} in
		y) expr="s:.*\<CONFIG_$1\>.*set:CONFIG_$1=y:g" ;;
		n) expr="s:CONFIG_$1=y:# CONFIG_$1 is not set:g" ;;
		*) expr="s:.*\<CONFIG_$1\>.*:CONFIG_$1=${flag}:g" ;;
		esac
		sed -i -e "${expr}" .config || die
		einfo "$(grep "CONFIG_$1[= ]" .config || echo "Could not find CONFIG_$1 ...")"
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

# patches go here!
PATCHES=(
	"${FILESDIR}"/${PN}-1.26.2-bb.patch
	"${FILESDIR}"/${PN}-1.34.1-skip-selinux-search.patch

	"${FILESDIR}"/${PN}-1.36.0-fortify-source-3-fixdep.patch
	"${FILESDIR}"/${PN}-1.36.1-kernel-6.8.patch

	"${FILESDIR}"/${PN}-1.37.0-skip-dynamic-relocations.patch

	"${FILESDIR}"/${PN}-1.37.0-sha-ni-fix.patch
)

src_prepare() {
	default

	cp "${FILESDIR}"/ginit.c init/ || die

	# flag cleanup
	sed -i -r \
		-e 's:[[:space:]]?-(Werror|Os|Oz|falign-(functions|jumps|loops|labels)=1|fomit-frame-pointer)\>::g' \
		Makefile.flags || die
	sed -i \
		-e 's:-static-libgcc::' \
		Makefile.flags || die

	# Print all link lines too
	sed -i -e 's:debug=false:debug=true:' scripts/trylink || die
}

bbmake() {
	local args=(
		V=1
		CROSS_COMPILE="${CHOST}-"
		AR="${AR}"
		CC="${CC}"
		HOSTCC="${BUILD_CC}"
		HOSTCFLAGS="${BUILD_CFLAGS}"
		PKG_CONFIG="${PKG_CONFIG}"
	)
	emake "${args[@]}" "$@"
}

src_configure() {
	unset KBUILD_OUTPUT #88088
	export SKIP_STRIP=y

	tc-export AR CC BUILD_CC PKG_CONFIG

	tc-is-cross-compiler || BUILD_CFLAGS=${CFLAGS}
	BUILD_CFLAGS+=" -D_FILE_OFFSET_BITS=64" #930513

	append-flags -fno-strict-aliasing #310413
	use ppc64 && append-flags -mminimal-toc #130943

	# check for a busybox config before making one of our own.
	# if one exist lets return and use it.
	restore_config .config
	if [ -f .config ]; then
		yes "" | bbmake -j1 oldconfig
		return 0
	else
		ewarn "Could not locate user configfile, so we will save a default one"
	fi

	# setting SKIP_SELINUX skips searching for selinux at this stage. We don't
	# need to search now in case we end up not needing it after all.
	# setup the config file
	bbmake -j1 allyesconfig SKIP_SELINUX=$(usex selinux n y) # bug #620918
	# nommu forces a bunch of things off which we want on bug #387555
	busybox_config_option n NOMMU
	sed -i '/^#/d' .config
	yes "" | bbmake -j1 oldconfig SKIP_SELINUX=$(usex selinux n y) #620918

	# now turn off stuff we really don't want
	busybox_config_option n DMALLOC
	busybox_config_option n FEATURE_2_4_MODULES #607548
	busybox_config_option n FEATURE_SUID_CONFIG
	busybox_config_option n BUILD_AT_ONCE
	busybox_config_option n BUILD_LIBBUSYBOX
	busybox_config_option n FEATURE_CLEAN_UP
	busybox_config_option n MONOTONIC_SYSCALL
	busybox_config_option n USE_PORTABLE_CODE
	busybox_config_option n WERROR
	# CONFIG_MODPROBE_SMALL=y disables depmod.c and uses a smaller one that
	# does not support -b. Setting this to no creates slightly larger and
	# slightly more useful modutils
	busybox_config_option n MODPROBE_SMALL # bug #472464
	# triming the BSS size may be dangerous
	busybox_config_option n FEATURE_USE_BSS_TAIL

	# These cause trouble with musl.
	if use elibc_musl; then
		busybox_config_option n FEATURE_UTMP
		busybox_config_option n EXTRA_COMPAT
		busybox_config_option n FEATURE_VI_REGEX_SEARCH
	fi

	# Disable standalone shell mode when using make-symlinks, else Busybox calls its
	# applets by default without looking up in PATH.
	# This also enables users to disable a builtin by deleting the corresponding symlink.
	if use make-symlinks; then
		busybox_config_option n FEATURE_PREFER_APPLETS
		busybox_config_option n FEATURE_SH_STANDALONE
	fi

	# If these are not set and we are using a busybox setup
	# all calls to system() will fail.
	busybox_config_option y ASH
	busybox_config_option y SH_IS_ASH
	busybox_config_option n HUSH
	busybox_config_option n SH_IS_HUSH

	busybox_config_option '"/run"' PID_FILE_PATH
	busybox_config_option '"/run/ifstate"' IFUPDOWN_IFSTATE_PATH

	busybox_config_option pam PAM
	busybox_config_option static STATIC
	busybox_config_option syslog {K,SYS}LOGD LOGGER
	busybox_config_option systemd FEATURE_SYSTEMD
	busybox_config_option math FEATURE_AWK_LIBM

	# all the debug options are compiler related, so punt them
	busybox_config_option n DEBUG_SANITIZE
	busybox_config_option n DEBUG
	busybox_config_option y NO_DEBUG_LIB
	busybox_config_option n DMALLOC
	busybox_config_option n EFENCE
	busybox_config_option $(usex debug y n) TFTP_DEBUG

	busybox_config_option selinux SELINUX

	# this opt only controls mounting with <linux-2.6.23
	busybox_config_option n FEATURE_MOUNT_NFS

	# glibc-2.26 and later does not ship RPC implientation
	busybox_config_option n FEATURE_HAVE_RPC
	busybox_config_option n FEATURE_INETD_RPC

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

	bbmake -j1 oldconfig
}

src_compile() {
	bbmake busybox

	# bug #701512
	bbmake doc
}

src_install() {
	unset KBUILD_OUTPUT # bug #88088
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
		cp "${S}"/examples/mdev_fat.conf "${ED}"/etc/mdev.conf || die
		if [[ ! "$(get_libdir)" == "lib" ]]; then
			# bug #831251 - replace lib with lib64 where appropriate
			sed -i -e "s:/lib/:/$(get_libdir)/:g" "${ED}"/etc/mdev.conf || die
		fi

		exeinto /$(get_libdir)/mdev/
		doexe "${FILESDIR}"/mdev/*

		newinitd "${FILESDIR}"/mdev.initd mdev
	fi
	if use livecd ; then
		dosym busybox /bin/vi
	fi

	# add busybox daemon's, bug #444718
	if busybox_config_enabled FEATURE_NTPD_SERVER; then
		newconfd "${FILESDIR}"/ntpd.confd busybox-ntpd
		newinitd "${FILESDIR}"/ntpd.initd busybox-ntpd
	fi
	if busybox_config_enabled SYSLOGD; then
		newconfd "${FILESDIR}"/syslogd.confd busybox-syslogd
		newinitd "${FILESDIR}"/syslogd.initd busybox-syslogd
	fi
	if busybox_config_enabled KLOGD; then
		newconfd "${FILESDIR}"/klogd.confd busybox-klogd
		newinitd "${FILESDIR}"/klogd.initd busybox-klogd
	fi
	if busybox_config_enabled WATCHDOG; then
		newconfd "${FILESDIR}"/watchdog.confd busybox-watchdog
		newinitd "${FILESDIR}"/watchdog.initd busybox-watchdog
	fi
	if busybox_config_enabled UDHCPC; then
		sed -i 's:$((metric++)):$metric; metric=$((metric + 1)):' examples/udhcp/simple.script || die #801535
		local path=$(busybox_config_enabled UDHCPC_DEFAULT_SCRIPT)
		exeinto "${path%/*}"
		newexe examples/udhcp/simple.script "${path##*/}"
	fi
	if busybox_config_enabled UDHCPD; then
		insinto /etc
		doins examples/udhcp/udhcpd.conf
	fi
	if busybox_config_enabled ASH && ! use make-symlinks; then
		dosym -r /bin/busybox /bin/ash
	fi
	if busybox_config_enabled CROND; then
		newconfd "${FILESDIR}"/crond.confd busybox-crond
		newinitd "${FILESDIR}"/crond.initd busybox-crond
	fi

	# bundle up the symlink files for use later
	bbmake DESTDIR="${ED}" install
	# for compatibility, provide /usr/bin/env
	mkdir -p _install/usr/bin || die
	if [[ ! -e _install/usr/bin/env ]]; then
		ln -s /bin/env _install/usr/bin/env || die
	fi
	rm _install/bin/busybox || die
	tar cf busybox-links.tar -C _install . || : #;die
	insinto /usr/share/${PN}
	use make-symlinks && doins busybox-links.tar

	dodoc AUTHORS README TODO

	cd docs || die
	doman busybox.1
	docinto txt
	dodoc *.txt
	docinto pod
	dodoc *.pod
	docinto html
	dodoc *.html

	cd ../examples || die
	docinto examples
	dodoc inittab depmod.pl *.conf *.script undeb unrpm

	cd ../networking || die
	dodoc httpd_indexcgi.c httpd_post_upload.cgi

	readme.gentoo_create_doc
}

pkg_preinst() {
	if use make-symlinks ; then
		mv "${ED}"/usr/share/${PN}/busybox-links.tar "${T}"/ || die
		rmdir "${ED}"/usr/share/${PN} || die
	fi
}

pkg_postinst() {
	savedconfig_pkg_postinst

	if use make-symlinks ; then
		cd "${T}" || die
		mkdir -p _install || die
		tar xf busybox-links.tar -C _install || die
		# Use --update=none from coreutils-9.2 instead of -n, add || die
		# Skip legacy linuxrc link, if anyone really needs it they can create it manually
		cp -vpP --update=none _install/bin/* "${ROOT}"/bin/ || die
		cp -vpP --update=none _install/sbin/* "${ROOT}"/sbin/ || die
		cp -vpP --update=none _install/usr/bin/* "${ROOT}"/usr/bin/ || die
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

	if [[ ${MERGE_TYPE} != binary ]] && ! is-flagq -Oz; then
		if ver_replacing -le 1.36.1; then
			FORCE_PRINT_ELOG=yes
		fi

		readme.gentoo_print_elog
	fi
}
