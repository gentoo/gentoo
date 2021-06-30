# Copyright 2011-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	if [[ ${PV} == *.* ]]; then
		MY_PN=systemd-stable
	else
		MY_PN=systemd
	fi
	MY_PV=${PV/_/-}
	MY_P=${MY_PN}-${MY_PV}
	S=${WORKDIR}/${MY_P}
	SRC_URI="https://github.com/systemd/${MY_PN}/archive/v${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

PYTHON_COMPAT=( python3_{7..9} )

inherit bash-completion-r1 linux-info meson-multilib pam python-any-r1 systemd toolchain-funcs udev usr-ldscript

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
IUSE="acl apparmor audit build cgroup-hybrid cryptsetup curl dns-over-tls elfutils +gcrypt gnuefi homed http +hwdb idn importd +kmod +lz4 lzma nat pam pcre pkcs11 policykit pwquality qrcode repart +resolvconf +seccomp selinux split-usr static-libs +sysv-utils test tpm vanilla xkb +zstd"

REQUIRED_USE="
	homed? ( cryptsetup pam )
	importd? ( curl gcrypt lzma )
	pwquality? ( homed )
"
RESTRICT="!test? ( test )"

MINKV="3.11"

OPENSSL_DEP=">=dev-libs/openssl-1.1.0:0="

COMMON_DEPEND=">=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	virtual/libcrypt:=[${MULTILIB_USEDEP}]
	acl? ( sys-apps/acl:0= )
	apparmor? ( sys-libs/libapparmor:0= )
	audit? ( >=sys-process/audit-2:0= )
	cryptsetup? ( >=sys-fs/cryptsetup-2.0.1:0= )
	curl? ( net-misc/curl:0= )
	dns-over-tls? ( >=net-libs/gnutls-3.6.0:0= )
	elfutils? ( >=dev-libs/elfutils-0.158:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )
	homed? ( ${OPENSSL_DEP} )
	http? (
		>=net-libs/libmicrohttpd-0.9.33:0=[epoll(+)]
		>=net-libs/gnutls-3.1.4:0=
	)
	idn? ( net-dns/libidn2:= )
	importd? (
		app-arch/bzip2:0=
		sys-libs/zlib:0=
	)
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p131:0=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	nat? ( net-firewall/iptables:0= )
	pam? ( sys-libs/pam:=[${MULTILIB_USEDEP}] )
	pkcs11? ( app-crypt/p11-kit:0= )
	pcre? ( dev-libs/libpcre2 )
	pwquality? ( dev-libs/libpwquality:0= )
	qrcode? ( media-gfx/qrencode:0= )
	repart? ( ${OPENSSL_DEP} )
	seccomp? ( >=sys-libs/libseccomp-2.3.3:0= )
	selinux? ( sys-libs/libselinux:0= )
	tpm? ( app-crypt/tpm2-tss:0= )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1:0= )
	zstd? ( >=app-arch/zstd-1.4.0:0=[${MULTILIB_USEDEP}] )
"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-${MINKV}
	gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=acct-group/adm-0-r1
	>=acct-group/wheel-0-r1
	>=acct-group/kmem-0-r1
	>=acct-group/tty-0-r1
	>=acct-group/utmp-0-r1
	>=acct-group/audio-0-r1
	>=acct-group/cdrom-0-r1
	>=acct-group/dialout-0-r1
	>=acct-group/disk-0-r1
	>=acct-group/input-0-r1
	>=acct-group/kvm-0-r1
	>=acct-group/lp-0-r1
	>=acct-group/render-0-r1
	acct-group/sgx
	>=acct-group/tape-0-r1
	acct-group/users
	>=acct-group/video-0-r1
	>=acct-group/systemd-journal-0-r1
	>=acct-user/root-0-r1
	acct-user/nobody
	>=acct-user/systemd-journal-remote-0-r1
	>=acct-user/systemd-coredump-0-r1
	>=acct-user/systemd-network-0-r1
	acct-user/systemd-oom
	>=acct-user/systemd-resolve-0-r1
	>=acct-user/systemd-timesync-0-r1
	>=sys-apps/baselayout-2.2
	selinux? ( sec-policy/selinux-base-policy[systemd] )
	sysv-utils? (
		!sys-apps/openrc[sysv-utils(-)]
		!sys-apps/sysvinit
	)
	!sysv-utils? ( sys-apps/sysvinit )
	resolvconf? ( !net-dns/openresolv )
	!build? ( || (
		sys-apps/util-linux[kill(-)]
		sys-process/procps[kill(+)]
		sys-apps/coreutils[kill(-)]
	) )
	!sys-auth/nss-myhostname
	!sys-fs/eudev
	!sys-fs/udev
"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND=">=sys-apps/dbus-1.9.8[systemd]
	hwdb? ( sys-apps/hwids[systemd(+),udev] )
	>=sys-fs/udev-init-scripts-34
	policykit? ( sys-auth/polkit )
	!vanilla? ( sys-apps/gentoo-systemd-integration )"

BDEPEND="
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/meson-0.46
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	sys-devel/m4
	virtual/pkgconfig
	test? ( sys-apps/dbus )
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]" &&
	has_version -b "dev-python/lxml[${PYTHON_USEDEP}]"
}

QA_EXECSTACK="usr/lib/systemd/boot/efi/*"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if use test && has pid-sandbox ${FEATURES}; then
			ewarn "Tests are known to fail with PID sandboxing enabled."
			ewarn "See https://bugs.gentoo.org/674458."
		fi

		local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
			~CHECKPOINT_RESTORE ~DEVTMPFS ~EPOLL ~FANOTIFY ~FHANDLE
			~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
			~TIMERFD ~TMPFS_XATTR ~UNIX ~USER_NS
			~CRYPTO_HMAC ~CRYPTO_SHA256 ~CRYPTO_USER_API_HASH
			~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
			~!SYSFS_DEPRECATED_V2"

		use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
		use seccomp && CONFIG_CHECK+=" ~SECCOMP ~SECCOMP_FILTER"
		kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"
		kernel_is -lt 4 7 && CONFIG_CHECK+=" ~DEVPTS_MULTIPLE_INSTANCES"
		kernel_is -ge 4 10 && CONFIG_CHECK+=" ~CGROUP_BPF"

		if linux_config_exists; then
			local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [[ -n ${uevent_helper_path} ]] && [[ ${uevent_helper_path} != '""' ]]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
			if linux_chkconfig_present X86; then
				CONFIG_CHECK+=" ~DMIID"
			fi
		fi

		if kernel_is -lt ${MINKV//./ }; then
			ewarn "Kernel version at least ${MINKV} required"
		fi

		check_extra_config
	fi
}

pkg_setup() {
	:
}

src_unpack() {
	default
	[[ ${PV} != 9999 ]] || git-r3_src_unpack
}

src_prepare() {
	# Do NOT add patches here
	local PATCHES=()

	[[ -d "${WORKDIR}"/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	# Add local patches here
	PATCHES+=(
	)

	if ! use vanilla; then
		PATCHES+=(
			"${FILESDIR}/gentoo-generator-path-r2.patch"
			"${FILESDIR}/gentoo-systemctl-disable-sysv-sync-r1.patch"
			"${FILESDIR}/gentoo-journald-audit.patch"
		)
	fi

	default
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	python_setup

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		-Dsupport-url="https://gentoo.org/support/"
		-Dpamlibdir="$(getpam_mod_dir)"
		# avoid bash-completion dep
		-Dbashcompletiondir="$(get_bashcompdir)"
		# make sure we get /bin:/sbin in PATH
		$(meson_use split-usr)
		-Dsplit-bin=true
		-Drootprefix="$(usex split-usr "${EPREFIX:-/}" "${EPREFIX}/usr")"
		-Drootlibdir="${EPREFIX}/usr/$(get_libdir)"
		# Avoid infinite exec recursion, bug 642724
		-Dtelinit-path="${EPREFIX}/lib/sysvinit/telinit"
		# no deps
		-Dima=true
		-Ddefault-hierarchy=$(usex cgroup-hybrid hybrid unified)
		# Optional components/dependencies
		$(meson_native_use_bool acl)
		$(meson_native_use_bool apparmor)
		$(meson_native_use_bool audit)
		$(meson_native_use_bool cryptsetup libcryptsetup)
		$(meson_native_use_bool curl libcurl)
		$(meson_native_use_bool dns-over-tls dns-over-tls)
		$(meson_native_use_bool elfutils)
		$(meson_use gcrypt)
		$(meson_native_use_bool gnuefi gnu-efi)
		-Defi-includedir="${ESYSROOT}/usr/include/efi"
		-Defi-ld="$(tc-getLD)"
		-Defi-libdir="${ESYSROOT}/usr/$(get_libdir)"
		$(meson_native_use_bool homed)
		$(meson_native_use_bool hwdb)
		$(meson_native_use_bool http microhttpd)
		$(meson_native_use_bool idn)
		$(meson_native_use_bool importd)
		$(meson_native_use_bool importd bzip2)
		$(meson_native_use_bool importd zlib)
		$(meson_native_use_bool kmod)
		$(meson_use lz4)
		$(meson_use lzma xz)
		$(meson_use zstd)
		$(meson_native_use_bool nat libiptc)
		$(meson_use pam)
		$(meson_native_use_bool pkcs11 p11kit)
		$(meson_native_use_bool pcre pcre2)
		$(meson_native_use_bool policykit polkit)
		$(meson_native_use_bool pwquality)
		$(meson_native_use_bool qrcode qrencode)
		$(meson_native_use_bool repart)
		$(meson_native_use_bool seccomp)
		$(meson_native_use_bool selinux)
		$(meson_native_use_bool tpm tpm2)
		$(meson_native_use_bool test dbus)
		$(meson_native_use_bool xkb xkbcommon)
		-Dntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"
		# Breaks screen, tmux, etc.
		-Ddefault-kill-user-processes=false
		-Dcreate-log-dirs=false

		# multilib options
		$(meson_native_true backlight)
		$(meson_native_true binfmt)
		$(meson_native_true coredump)
		$(meson_native_true environment-d)
		$(meson_native_true firstboot)
		$(meson_native_true hibernate)
		$(meson_native_true hostnamed)
		$(meson_native_true ldconfig)
		$(meson_native_true localed)
		$(meson_native_true man)
		$(meson_native_true networkd)
		$(meson_native_true quotacheck)
		$(meson_native_true randomseed)
		$(meson_native_true rfkill)
		$(meson_native_true sysusers)
		$(meson_native_true timedated)
		$(meson_native_true timesyncd)
		$(meson_native_true tmpfiles)
		$(meson_native_true vconsole)

		# static-libs
		$(meson_use static-libs static-libsystemd)
		$(meson_use static-libs static-libudev)
	)

	meson_src_configure "${myconf[@]}"
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR
	meson_src_test
}

multilib_src_install_all() {
	local rootprefix=$(usex split-usr '' /usr)

	# meson doesn't know about docdir
	mv "${ED}"/usr/share/doc/{systemd,${PF}} || die

	einstalldocs
	dodoc "${FILESDIR}"/nsswitch.conf

	if ! use resolvconf; then
		rm -f "${ED}${rootprefix}"/sbin/resolvconf || die
	fi

	rm "${ED}"/etc/init.d/README || die
	rm "${ED}${rootprefix}"/lib/systemd/system-generators/systemd-sysv-generator || die

	if ! use sysv-utils; then
		rm "${ED}${rootprefix}"/sbin/{halt,init,poweroff,reboot,runlevel,shutdown,telinit} || die
		rm "${ED}"/usr/share/man/man1/init.1 || die
		rm "${ED}"/usr/share/man/man8/{halt,poweroff,reboot,runlevel,shutdown,telinit}.8 || die
	fi

	if ! use resolvconf && ! use sysv-utils; then
		rmdir "${ED}${rootprefix}"/sbin || die
	fi

	# https://bugs.gentoo.org/761763
	rm -r "${ED}"/usr/lib/sysusers.d || die

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/{binfmt.d,modules-load.d,tmpfiles.d}
	keepdir /etc/kernel/install.d
	keepdir /etc/systemd/{network,system,user}
	keepdir /etc/udev/rules.d

	if use hwdb; then
		keepdir /etc/udev/hwdb.d
	fi

	keepdir "${rootprefix}"/lib/systemd/{system-sleep,system-shutdown}
	keepdir /usr/lib/{binfmt.d,modules-load.d}
	keepdir /usr/lib/systemd/user-generators
	keepdir /var/lib/systemd
	keepdir /var/log/journal

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	if use pam; then
		newpamd "${FILESDIR}"/systemd-user.pam systemd-user
	fi

	if use hwdb; then
		rm -r "${ED}${rootprefix}"/lib/udev/hwdb.d || die
	fi

	if use split-usr; then
		# Avoid breaking boot/reboot
		dosym ../../../lib/systemd/systemd /usr/lib/systemd/systemd
		dosym ../../../lib/systemd/systemd-shutdown /usr/lib/systemd/systemd-shutdown
	fi

	gen_usr_ldscript -a systemd udev
}

migrate_locale() {
	local envd_locale_def="${EROOT}/etc/env.d/02locale"
	local envd_locale=( "${EROOT}"/etc/env.d/??locale )
	local locale_conf="${EROOT}/etc/locale.conf"

	if [[ ! -L ${locale_conf} && ! -e ${locale_conf} ]]; then
		# If locale.conf does not exist...
		if [[ -e ${envd_locale} ]]; then
			# ...either copy env.d/??locale if there's one
			ebegin "Moving ${envd_locale} to ${locale_conf}"
			mv "${envd_locale}" "${locale_conf}"
			eend ${?} || FAIL=1
		else
			# ...or create a dummy default
			ebegin "Creating ${locale_conf}"
			cat > "${locale_conf}" <<-EOF
				# This file has been created by the sys-apps/systemd ebuild.
				# See locale.conf(5) and localectl(1).

				# LANG=${LANG}
			EOF
			eend ${?} || FAIL=1
		fi
	fi

	if [[ ! -L ${envd_locale} ]]; then
		# now, if env.d/??locale is not a symlink (to locale.conf)...
		if [[ -e ${envd_locale} ]]; then
			# ...warn the user that he has duplicate locale settings
			ewarn
			ewarn "To ensure consistent behavior, you should replace ${envd_locale}"
			ewarn "with a symlink to ${locale_conf}. Please migrate your settings"
			ewarn "and create the symlink with the following command:"
			ewarn "ln -s -n -f ../locale.conf ${envd_locale}"
			ewarn
		else
			# ...or just create the symlink if there's nothing here
			ebegin "Creating ${envd_locale_def} -> ../locale.conf symlink"
			ln -n -s ../locale.conf "${envd_locale_def}"
			eend ${?} || FAIL=1
		fi
	fi
}

pkg_preinst() {
	if ! use split-usr; then
		local dir
		for dir in bin sbin lib; do
			if [[ ! ${EROOT}/${dir} -ef ${EROOT}/usr/${dir} ]]; then
				eerror "\"${EROOT}/${dir}\" and \"${EROOT}/usr/${dir}\" are not merged."
				eerror "One of them should be a symbolic link to the other one."
				FAIL=1
			fi
		done
		if [[ ${FAIL} ]]; then
			eerror "Migration to system layout with merged directories must be performed before"
			eerror "rebuilding ${CATEGORY}/${PN} with USE=\"-split-usr\" to avoid run-time breakage."
			die "System layout with split directories still used"
		fi
	fi
}

pkg_postinst() {
	systemd_update_catalog

	# Keep this here in case the database format changes so it gets updated
	# when required.
	if use hwdb; then
		systemd-hwdb --root="${ROOT}" update
	fi

	udev_reload || FAIL=1

	# Bug 465468, make sure locales are respected, and ensure consistency
	# between OpenRC & systemd
	migrate_locale

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if type systemctl &>/dev/null; then
			systemctl --root="${ROOT:-/}" enable getty@.service remote-fs.target || FAIL=1
		fi
		elog "To enable a useful set of services, run the following:"
		elog "  systemctl preset-all --preset-mode=enable-only"
	fi

	if [[ -L ${EROOT}/var/lib/systemd/timesync ]]; then
		rm "${EROOT}/var/lib/systemd/timesync"
	fi

	if [[ -z ${ROOT} && -d /run/systemd/system ]]; then
		ebegin "Reexecuting system manager"
		systemctl daemon-reexec
		eend $?
	fi

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
