# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz
		!doc? ( https://dev.gentoo.org/~floppym/dist/${P}-man.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit autotools bash-completion-r1 linux-info multilib-minimal pam python-any-r1 systemd toolchain-funcs udev user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
IUSE="acl apparmor audit cryptsetup curl doc elfutils +gcrypt gnuefi http
	idn importd +kmod +lz4 lzma nat pam policykit
	qrcode +seccomp selinux ssl sysv-utils test vanilla xkb"

REQUIRED_USE="importd? ( curl gcrypt lzma )"

MINKV="3.11"

COMMON_DEPEND=">=sys-apps/util-linux-2.27.1:0=[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.16
	acl? ( sys-apps/acl:0= )
	apparmor? ( sys-libs/libapparmor:0= )
	audit? ( >=sys-process/audit-2:0= )
	cryptsetup? ( >=sys-fs/cryptsetup-1.6:0= )
	curl? ( net-misc/curl:0= )
	elfutils? ( >=dev-libs/elfutils-0.158:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )
	http? (
		>=net-libs/libmicrohttpd-0.9.33:0=
		ssl? ( >=net-libs/gnutls-3.1.4:0= )
	)
	idn? ( net-dns/libidn:0= )
	importd? (
		app-arch/bzip2:0=
		sys-libs/zlib:0=
	)
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p131:0=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	nat? ( net-firewall/iptables:0= )
	pam? ( virtual/pam:= )
	qrcode? ( media-gfx/qrencode:0= )
	seccomp? ( sys-libs/libseccomp:0= )
	selinux? ( sys-libs/libselinux:0= )
	sysv-utils? (
		!sys-apps/systemd-sysv-utils
		!sys-apps/sysvinit )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1:0= )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2
	selinux? ( sec-policy/selinux-base-policy[systemd] )
	!sys-auth/nss-myhostname
	!<sys-kernel/dracut-044
	!sys-fs/eudev
	!sys-fs/udev"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND=">=sys-apps/dbus-1.8.8:0[systemd]
	>=sys-apps/hwids-20150417[udev]
	>=sys-fs/udev-init-scripts-25
	policykit? ( sys-auth/polkit )
	!vanilla? ( sys-apps/gentoo-systemd-integration )"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-devel/binutils-2.23.1
	>=sys-devel/gcc-4.6
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig
	gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	test? ( >=sys-apps/dbus-1.6.8-r1:0 )
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	doc? ( $(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]') )
"

python_check_deps() {
	has_version --host-root "dev-python/lxml[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
		~DEVTMPFS ~DMIID ~EPOLL ~FANOTIFY ~FHANDLE
		~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
		~TIMERFD ~TMPFS_XATTR ~UNIX
		~!FW_LOADER_USER_HELPER ~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
		~!SYSFS_DEPRECATED_V2"

	use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
	use seccomp && CONFIG_CHECK+=" ~SECCOMP ~SECCOMP_FILTER"
	kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"
	kernel_is -lt 4 7 && CONFIG_CHECK+=" ~DEVPTS_MULTIPLE_INSTANCES"

	if linux_config_exists; then
		local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [ -n "${uevent_helper_path}" ] && [ "${uevent_helper_path}" != '""' ]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
	fi

	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4
			|| ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ) ]]
		then
			eerror "systemd requires at least gcc 4.6 to build. Please switch the active"
			eerror "gcc version using gcc-config."
			die "systemd requires at least gcc 4.6"
		fi
	fi

	if [[ ${MERGE_TYPE} != buildonly ]]; then
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
	# Bug 463376
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die

	local PATCHES=(
		"${FILESDIR}/218-Dont-enable-audit-by-default.patch"
		"${FILESDIR}/228-noclean-tmp.patch"
	)
	[[ -d "${WORKDIR}"/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	default

	eautoreconf
}

src_configure() {
	# Keep using the one where the rules were installed.
	MY_UDEVDIR=$(get_udevdir)
	# Fix systems broken by bug #509454.
	[[ ${MY_UDEVDIR} ]] || MY_UDEVDIR=/lib/udev

	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	use doc && python_setup

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		# disable -flto since it is an optimization flag
		# and makes distcc less effective
		cc_cv_CFLAGS__flto=no
		# disable -fuse-ld=gold since Gentoo supports explicit linker
		# choice and forcing gold is undesired, #539998
		# ld.gold may collide with user's LDFLAGS, #545168
		# ld.gold breaks sparc, #573874
		cc_cv_LDFLAGS__Wl__fuse_ld_gold=no

		# Workaround for gcc-4.7, bug 554454.
		cc_cv_CFLAGS__Werror_shadow=no

		# Workaround for bug 516346
		--enable-dependency-tracking

		--disable-maintainer-mode
		--localstatedir=/var
		--with-pamlibdir=$(getpam_mod_dir)
		# avoid bash-completion dep
		--with-bashcompletiondir="$(get_bashcompdir)"
		# make sure we get /bin:/sbin in $PATH
		--enable-split-usr
		# For testing.
		--with-rootprefix="${ROOTPREFIX-/usr}"
		--with-rootlibdir="${ROOTPREFIX-/usr}/$(get_libdir)"
		# disable sysv compatibility
		--with-sysvinit-path=
		--with-sysvrcnd-path=
		# no deps
		--enable-efi
		--enable-ima

		# Optional components/dependencies
		$(multilib_native_use_enable acl)
		$(multilib_native_use_enable apparmor)
		$(multilib_native_use_enable audit)
		$(multilib_native_use_enable cryptsetup libcryptsetup)
		$(multilib_native_use_enable curl libcurl)
		$(multilib_native_use_enable elfutils)
		$(use_enable gcrypt)
		$(multilib_native_use_enable gnuefi)
		$(multilib_native_use_enable http microhttpd)
		$(usex http $(multilib_native_use_enable ssl gnutls) --disable-gnutls)
		$(multilib_native_use_enable idn libidn)
		$(multilib_native_use_enable importd)
		$(multilib_native_use_enable importd bzip2)
		$(multilib_native_use_enable importd zlib)
		$(multilib_native_use_enable kmod)
		$(use_enable lz4)
		$(use_enable lzma xz)
		$(multilib_native_use_enable nat libiptc)
		$(multilib_native_use_enable pam)
		$(multilib_native_use_enable policykit polkit)
		$(multilib_native_use_enable qrcode qrencode)
		$(multilib_native_use_enable seccomp)
		$(multilib_native_use_enable selinux)
		$(multilib_native_use_enable test tests)
		$(multilib_native_use_enable test dbus)
		$(multilib_native_use_enable xkb xkbcommon)
		$(multilib_native_use_with doc python)

		# hardcode a few paths to spare some deps
		KILL=/bin/kill
		QUOTAON=/usr/sbin/quotaon
		QUOTACHECK=/usr/sbin/quotacheck

		# TODO: we may need to restrict this to gcc
		EFI_CC="$(tc-getCC)"

		# dbus paths
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d"
		--with-dbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		--with-dbussystemservicedir="${EPREFIX}/usr/share/dbus-1/system-services"

		--with-ntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"

		# Breaks screen, tmux, etc.
		--without-kill-user-processes
	)

	# Work around bug 463846.
	tc-export CC

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	local mymakeopts=(
		udevlibexecdir="${MY_UDEVDIR}"
	)

	if multilib_is_native_abi; then
		emake "${mymakeopts[@]}"
	else
		echo 'gentoo: $(BUILT_SOURCES)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
		echo 'gentoo: $(lib_LTLIBRARIES) $(pkgconfiglib_DATA)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
	fi
}

multilib_src_test() {
	multilib_is_native_abi || return 0
	default
}

multilib_src_install() {
	local mymakeopts=(
		# automake fails with parallel libtool relinking
		# https://bugs.gentoo.org/show_bug.cgi?id=491398
		-j1

		udevlibexecdir="${MY_UDEVDIR}"
		dist_udevhwdb_DATA=
		DESTDIR="${D}"
	)

	if multilib_is_native_abi; then
		emake "${mymakeopts[@]}" install
	else
		mymakeopts+=(
			install-libLTLIBRARIES
			install-pkgconfiglibDATA
			install-includeHEADERS
			# safe to call unconditionally, 'installs' empty list
			install-pkgincludeHEADERS
		)

		emake "${mymakeopts[@]}"
	fi
}

multilib_src_install_all() {
	prune_libtool_files --modules
	einstalldocs

	if [[ ${PV} != 9999 ]]; then
		use doc || doman "${WORKDIR}"/man/systemd.{directives,index}.7
	fi

	if use sysv-utils; then
		for app in halt poweroff reboot runlevel shutdown telinit; do
			dosym "..${ROOTPREFIX-/usr}/bin/systemctl" /sbin/${app}
		done
		dosym "..${ROOTPREFIX-/usr}/lib/systemd/systemd" /sbin/init
	else
		# we just keep sysvinit tools, so no need for the mans
		rm "${D}"/usr/share/man/man8/{halt,poweroff,reboot,runlevel,shutdown,telinit}.8 \
			|| die
		rm "${D}"/usr/share/man/man1/init.1 || die
	fi

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/binfmt.d /etc/modules-load.d /etc/tmpfiles.d \
		/etc/systemd/ntp-units.d /etc/systemd/user /var/lib/systemd \
		/var/log/journal/remote

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	# If we install these symlinks, there is no way for the sysadmin to remove them
	# permanently.
	rm "${D}"/etc/systemd/system/multi-user.target.wants/systemd-networkd.service || die
	rm -f "${D}"/etc/systemd/system/multi-user.target.wants/systemd-resolved.service || die
	rm -r "${D}"/etc/systemd/system/network-online.target.wants || die
	rm -r "${D}"/etc/systemd/system/sockets.target.wants || die
	rm -r "${D}"/etc/systemd/system/sysinit.target.wants || die
}

migrate_locale() {
	local envd_locale_def="${EROOT%/}/etc/env.d/02locale"
	local envd_locale=( "${EROOT%/}"/etc/env.d/??locale )
	local locale_conf="${EROOT%/}/etc/locale.conf"

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

pkg_postinst() {
	newusergroup() {
		enewgroup "$1"
		enewuser "$1" -1 -1 -1 "$1"
	}

	enewgroup input
	enewgroup systemd-journal
	newusergroup systemd-bus-proxy
	newusergroup systemd-coredump
	newusergroup systemd-journal-gateway
	newusergroup systemd-journal-remote
	newusergroup systemd-journal-upload
	newusergroup systemd-network
	newusergroup systemd-resolve
	newusergroup systemd-timesync

	systemd_update_catalog

	# Keep this here in case the database format changes so it gets updated
	# when required. Despite that this file is owned by sys-apps/hwids.
	if has_version "sys-apps/hwids[udev]"; then
		udevadm hwdb --update --root="${ROOT%/}"
	fi

	udev_reload || FAIL=1

	# Bug 465468, make sure locales are respect, and ensure consistency
	# between OpenRC & systemd
	migrate_locale

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi

	if [[ $(readlink "${ROOT}"etc/resolv.conf) == */run/systemd/* ]]; then
		ewarn "You should replace the resolv.conf symlink:"
		ewarn "ln -snf ${ROOTPREFIX-/usr}/lib/systemd/resolv.conf ${ROOT}etc/resolv.conf"
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
