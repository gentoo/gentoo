# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

# Avoid QA warnings
TMPFILES_OPTIONAL=1
UDEV_OPTIONAL=1

QA_PKGCONFIG_VERSION=$(ver_cut 1)

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	S=${WORKDIR}/${MY_P}
	SRC_URI="https://github.com/systemd/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

	if [[ ${PV} != *rc* ]] ; then
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	fi
fi

inherit branding flag-o-matic linux-info meson-multilib optfeature pam python-single-r1
inherit secureboot shell-completion systemd toolchain-funcs udev

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://systemd.io/"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
IUSE="
	acl apparmor audit boot bpf cryptsetup curl +dns-over-tls elfutils
	fido2 +gcrypt gnutls homed idn importd +kernel-install +kmod +lz4 lzma
	+openssl pam passwdqc pcre pkcs11 policykit pwquality qrcode remote
	+resolvconf +seccomp selinux sysv-utils test tpm ukify vanilla xkb +zstd
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	boot? ( kernel-install )
	dns-over-tls? ( openssl )
	fido2? ( cryptsetup openssl )
	homed? ( cryptsetup pam openssl )
	importd? ( curl lzma openssl )
	?? ( passwdqc pwquality )
	passwdqc? ( homed )
	pwquality? ( homed )
	remote? ( curl )
	ukify? ( boot )
"
RESTRICT="!test? ( test )"

MINKV="5.10"

COMMON_DEPEND="
	>=sys-apps/util-linux-2.37
	acl? ( sys-apps/acl )
	apparmor? ( >=sys-libs/libapparmor-2.13 )
	audit? ( >=sys-process/audit-2 )
	bpf? ( >=dev-libs/libbpf-1.4.0 )
	cryptsetup? ( >=sys-fs/cryptsetup-2.4.0:= )
	curl? ( >=net-misc/curl-7.32.0:0= )
	elfutils? ( >=dev-libs/elfutils-0.177 )
	elibc_glibc? (
		>=sys-libs/glibc-2.34
		>=sys-libs/libxcrypt-4.4.0
	)
	elibc_musl? (
		>=sys-libs/musl-1.2.5-r8
		virtual/libcrypt
	)
	fido2? (
		dev-libs/libfido2
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5 )
	gnutls? ( >=net-libs/gnutls-3.6.0:0= )
	remote? ( >=net-libs/libmicrohttpd-0.9.33:0=[epoll(+)] )
	idn? ( net-dns/libidn2 )
	importd? (
		app-arch/bzip2:0=
		virtual/zlib:=
	)
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p131:0= )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0= )
	openssl? ( >=dev-libs/openssl-3.0.0:0= )
	pam? ( sys-libs/pam:=[${MULTILIB_USEDEP}] )
	passwdqc? ( sys-auth/passwdqc )
	pkcs11? ( >=app-crypt/p11-kit-0.23.3 )
	pcre? ( dev-libs/libpcre2 )
	pwquality? ( >=dev-libs/libpwquality-1.4.1 )
	qrcode? ( >=media-gfx/qrencode-3:0= )
	seccomp? ( >=sys-libs/libseccomp-2.4.0 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	tpm? ( app-crypt/tpm2-tss )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1 )
	zstd? ( >=app-arch/zstd-1.4.0:0= )
"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-${MINKV}
"

PEFILE_DEPEND='dev-python/pefile[${PYTHON_USEDEP}]'

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=acct-group/adm-0-r1
	>=acct-group/wheel-0-r1
	>=acct-group/kmem-0-r1
	>=acct-group/tty-0-r1
	>=acct-group/utmp-0-r1
	>=acct-group/audio-0-r1
	>=acct-group/cdrom-0-r1
	acct-group/clock
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
	ukify? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep "${PEFILE_DEPEND}")
	)
	selinux? (
		sec-policy/selinux-base-policy[systemd]
		sec-policy/selinux-ntp
	)
	sysv-utils? (
		!sys-apps/openrc[sysv-utils(-)]
		!sys-apps/sysvinit
	)
	!sysv-utils? ( sys-apps/sysvinit )
	resolvconf? ( !net-dns/openresolv )
	!sys-auth/nss-myhostname
	!sys-fs/eudev
	!sys-fs/udev
"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND="
	>=sys-apps/dbus-1.9.8[systemd]
	>=sys-fs/udev-init-scripts-34
	policykit? ( sys-auth/polkit )
	!sysv-utils? ( sys-apps/systemd-initctl )
	!vanilla? ( sys-apps/gentoo-systemd-integration )
"

BDEPEND="
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-build/meson-0.46
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
	bpf? (
		>=dev-util/bpftool-7.0.0
		sys-devel/bpf-toolchain
	)
	test? (
		app-text/tree
		dev-lang/perl
		>=dev-libs/glib-2.22.0:2
		sys-apps/dbus
	)
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	${PYTHON_DEPS}
	$(python_gen_cond_dep "
		dev-python/jinja2[\${PYTHON_USEDEP}]
		dev-python/lxml[\${PYTHON_USEDEP}]
		boot? (
			>=dev-python/pyelftools-0.30[\${PYTHON_USEDEP}]
			test? ( ${PEFILE_DEPEND} )
		)
	")
"

QA_FLAGS_IGNORED="usr/lib/systemd/boot/efi/.*"
QA_EXECSTACK="usr/lib/systemd/boot/efi/*"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~BLK_DEV_BSG ~CGROUPS
			~CGROUP_BPF ~DEVTMPFS ~EPOLL ~FANOTIFY ~FHANDLE
			~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
			~TIMERFD ~TMPFS_XATTR ~UNIX ~USER_NS
			~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
			~!SYSFS_DEPRECATED_V2"

		use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
		use bpf && CONFIG_CHECK+=" ~BPF ~BPF_SYSCALL ~BPF_LSM ~DEBUG_INFO_BTF"
		use seccomp && CONFIG_CHECK+=" ~SECCOMP ~SECCOMP_FILTER"

		if kernel_is -ge 5 10 20; then
			CONFIG_CHECK+=" ~KCMP"
		else
			CONFIG_CHECK+=" ~CHECKPOINT_RESTORE"
		fi

		if kernel_is -ge 4 18; then
			CONFIG_CHECK+=" ~AUTOFS_FS"
		else
			CONFIG_CHECK+=" ~AUTOFS4_FS"
		fi

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
	use boot && secureboot_pkg_setup
}

src_unpack() {
	default
	[[ ${PV} != 9999 ]] || git-r3_src_unpack
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/systemd-260.1-fuzz-journald.patch"
		"${FILESDIR}/systemd-260.1-openssl-4.patch"
		"${FILESDIR}/systemd-260.1-gcc-17.patch"
		"${FILESDIR}/systemd-260.1-gpt-generator.patch"
	)

	if ! use vanilla; then
		PATCHES+=(
			"${FILESDIR}/gentoo-journald-audit-r4.patch"
		)
	fi

	default
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	# Our toolchain sets F_S=2 by default w/ >= -O2, so we need
	# to unset F_S first, then explicitly set 2, to negate any default
	# and anything set by the user if they're choosing 3 (or if they've
	# modified GCC to set 3).
	#
	# malloc_usable_size doesn't play well with _F_S=3:
	#  https://github.com/systemd/systemd/issues/41459 (bug #971773)
	if tc-is-clang && tc-enables-fortify-source ; then
		# We can't unconditionally do this b/c we fortify needs
		# some level of optimisation.
		filter-flags -D_FORTIFY_SOURCE=3
		append-cppflags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
	fi

	python_setup

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		-Ddocdir="share/doc/${PF}"
		-Dmode=release # default is developer, bug 918671
		-Dlibc=$(usex elibc_musl musl glibc)
		-Dsupport-url="${BRANDING_OS_SUPPORT_URL}"
		-Dpamlibdir="$(getpam_mod_dir)"
		-Dbashcompletiondir="$(get_bashcompdir)"
		-Dzshcompletiondir="$(get_zshcompdir)"
		-Dsplit-bin=false
		-Dima=true # no deps
		-Ddebug-shell="${EPREFIX}/bin/sh" # Match /etc/shells, bug 919749
		-Ddefault-user-shell="${EPREFIX}/bin/bash"
		-Dbpf-compiler=gcc
		-Dntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"
		# Breaks screen, tmux, etc.
		-Ddefault-kill-user-processes=false
		-Dcreate-log-dirs=false
		-Dlibcrypt=enabled
		-Dcompat-mutable-uid-boundaries=true

		# options affecting multilib
		$(meson_use !elibc_musl nss-myhostname)
		$(meson_feature !elibc_musl nss-mymachines)
		$(meson_feature !elibc_musl nss-resolve)
		$(meson_use !elibc_musl nss-systemd)
		$(meson_feature pam)
	)

	# workaround for bug 969103
	if [[ ${CHOST} == riscv32* ]] ; then
		myconf+=( -Dtests=true )
	else
		myconf+=( $(meson_use test tests) )
	fi

	if multilib_is_native_abi; then
		myconf+=(
			--auto-features=enabled
			-Dman=enabled
			-Dxenctrl=disabled

			# Optional components/dependencies
			$(meson_feature acl)
			$(meson_feature apparmor)
			$(meson_feature audit)
			$(meson_feature boot bootloader)
			$(meson_feature bpf bpf-framework)
			$(meson_feature cryptsetup libcryptsetup)
			$(meson_feature cryptsetup libcryptsetup-plugins)
			$(meson_feature curl libcurl)
			$(meson_use dns-over-tls dns-over-tls)
			$(meson_feature elfutils)
			$(meson_feature fido2 libfido2)
			$(meson_feature gcrypt)
			$(meson_feature gnutls)
			$(meson_feature homed)
			$(meson_use idn)
			$(meson_feature importd)
			$(meson_feature importd bzip2)
			$(meson_feature importd sysupdate)
			$(meson_feature importd zlib)
			$(meson_use kernel-install)
			$(meson_feature kmod)
			$(meson_feature lz4)
			$(meson_feature lzma xz)
			$(meson_feature zstd)
			$(meson_feature openssl)
			$(meson_feature passwdqc)
			$(meson_feature pkcs11 p11kit)
			$(meson_feature pcre pcre2)
			$(meson_feature policykit polkit)
			$(meson_feature pwquality)
			$(meson_feature qrcode qrencode)
			$(meson_feature remote)
			$(meson_feature remote microhttpd)
			$(meson_feature seccomp)
			$(meson_feature selinux)
			$(meson_feature tpm tpm2)
			$(meson_feature test dbus)
			$(meson_feature test glib)
			$(meson_feature ukify)
			$(meson_feature xkb xkbcommon)
		)

		case $(tc-arch) in
			amd64|arm|arm64|loong|ppc|ppc64|riscv|s390|x86)
				# src/vmspawn/vmspawn-util.h: QEMU_MACHINE_TYPE
				myconf+=( $(meson_native_enabled vmspawn) ) ;;
			*)
				myconf+=( -Dvmspawn=disabled ) ;;
		esac
	else
		myconf+=(
			--auto-features=disabled
		)
	fi

	meson_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	local args=()
	if ! multilib_is_native_abi; then
		args+=(
			devel libsystemd libudev
			$(usex elibc_musl '' nss)
			$(usev pam)
		)
	fi
	meson_src_compile "${args[@]}"
}

multilib_src_test() {
	local args=( --timeout-multiplier=10 )
	if ! multilib_is_native_abi; then
		args+=(
			--suite libsystemd --suite libudev
			$(usex elibc_musl '' '--suite nss')
			$(usex pam '--suite pam' '')
		)
	fi
	(
		unset DBUS_SESSION_BUS_ADDRESS XDG_RUNTIME_DIR
		export COLUMNS=80
		addpredict /dev
		addpredict /proc
		addpredict /run
		addpredict /sys/fs/cgroup
		meson_src_test "${args[@]}"
	) || die
}

multilib_src_install() {
	local args=()
	if ! multilib_is_native_abi; then
		local tags=devel,libsystemd,libudev
		use !elibc_musl && tags+=,nss
		use pam && tags+=,pam
		args+=( --tags "${tags}" )
	fi
	meson_src_install "${args[@]}"
}

multilib_src_install_all() {
	einstalldocs
	dodoc "${FILESDIR}"/nsswitch.conf

	insinto /usr/lib/tmpfiles.d
	doins "${FILESDIR}"/legacy.conf

	if ! use resolvconf; then
		rm -f "${ED}"/usr/bin/resolvconf || die
	fi

	if ! use sysv-utils; then
		rm "${ED}"/usr/bin/{halt,init,poweroff,reboot,shutdown} || die
		rm "${ED}"/usr/share/man/man1/init.1 || die
		rm "${ED}"/usr/share/man/man8/{halt,poweroff,reboot,shutdown}.8 || die
	fi

	# https://bugs.gentoo.org/761763
	rm -r "${ED}"/usr/lib/sysusers.d || die

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/{binfmt.d,modules-load.d,tmpfiles.d}
	keepdir /etc/kernel/install.d
	keepdir /etc/systemd/{network,system,user}
	keepdir /etc/udev/rules.d

	keepdir /etc/udev/hwdb.d

	keepdir /usr/lib/systemd/{system-sleep,system-shutdown}
	keepdir /usr/lib/{binfmt.d,modules-load.d}
	keepdir /usr/lib/systemd/user-generators
	keepdir /var/lib/systemd
	keepdir /var/log/journal

	if use pam; then
		if use selinux; then
			newpamd "${FILESDIR}"/systemd-user-selinux.pam systemd-user
		else
			newpamd "${FILESDIR}"/systemd-user.pam systemd-user
		fi
	fi

	if use kernel-install; then
		# Dummy config, remove to make room for sys-kernel/installkernel
		rm "${ED}/usr/lib/kernel/install.conf" || die
	fi

	use ukify && python_fix_shebang "${ED}"
	use boot && secureboot_auto_sign
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
	if [[ -e ${EROOT}/etc/sysctl.conf ]]; then
		# Symlink /etc/sysctl.conf for easy migration.
		dosym ../../../etc/sysctl.conf /usr/lib/sysctl.d/99-sysctl.conf
	fi

	if ! use boot && has_version "sys-apps/systemd[gnuefi(-)]"; then
		ewarn "The 'gnuefi' USE flag has been renamed to 'boot'."
		ewarn "Make sure to enable the 'boot' USE flag if you use systemd-boot."
	fi
}

pkg_postinst() {
	systemd_update_catalog

	# Keep this here in case the database format changes so it gets updated
	# when required.
	udev_hwdb_update || FAIL=1
	udev_reload || FAIL=1

	# Bug 465468, make sure locales are respected, and ensure consistency
	# between OpenRC & systemd
	migrate_locale

	# Bug 971385
	systemd_reenable getty@.service

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
		ebegin "Reexecuting system manager (systemd)"
		systemctl daemon-reexec
		eend $? || FAIL=1

		# https://lists.freedesktop.org/archives/systemd-devel/2024-June/050466.html
		ebegin "Signaling user managers to reexec"
		systemctl kill --kill-whom='main' --signal='SIGRTMIN+25' 'user@*.service'
		eend $?
	fi

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi

	if use boot; then
		optfeature "installing kernels in systemd-boot's native layout and update loader entries" \
			"sys-kernel/installkernel[systemd-boot]"
	fi
	if use ukify; then
		optfeature "generating unified kernel image on each kernel installation" \
			"sys-kernel/installkernel[ukify]"
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
