# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit autotools-utils bash-completion-r1 linux-info multilib \
	multilib-minimal pam python-single-r1 systemd toolchain-funcs udev \
	user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="https://www.freedesktop.org/software/systemd/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="acl apparmor audit cryptsetup curl doc elfutils gcrypt gudev http
	idn introspection kdbus +kmod +lz4 lzma pam policykit python qrcode +seccomp
	selinux ssl sysv-utils terminal test vanilla xkb"

MINKV="3.8"

COMMON_DEPEND=">=sys-apps/util-linux-2.25:0=
	sys-libs/libcap:0=
	!<sys-libs/glibc-2.16
	acl? ( sys-apps/acl:0= )
	apparmor? ( sys-libs/libapparmor:0= )
	audit? ( >=sys-process/audit-2:0= )
	cryptsetup? ( >=sys-fs/cryptsetup-1.6:0= )
	curl? ( net-misc/curl:0= )
	elfutils? ( >=dev-libs/elfutils-0.158:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )
	gudev? ( >=dev-libs/glib-2.34.3:2=[${MULTILIB_USEDEP}] )
	http? (
		>=net-libs/libmicrohttpd-0.9.33:0=
		ssl? ( >=net-libs/gnutls-3.1.4:0= )
	)
	idn? ( net-dns/libidn:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:0= )
	kmod? ( >=sys-apps/kmod-15:0= )
	lz4? ( >=app-arch/lz4-0_p119:0=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	pam? ( virtual/pam:= )
	python? ( ${PYTHON_DEPS} )
	qrcode? ( media-gfx/qrencode:0= )
	seccomp? ( sys-libs/libseccomp:0= )
	selinux? ( sys-libs/libselinux:0= )
	sysv-utils? (
		!sys-apps/systemd-sysv-utils
		!sys-apps/sysvinit )
	terminal? ( >=dev-libs/libevdev-1.2:0=
		>=x11-libs/libxkbcommon-0.5:0=
		>=x11-libs/libdrm-2.4:0= )
	xkb? ( >=x11-libs/libxkbcommon-0.4.1:0= )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2
	!sys-auth/nss-myhostname
	!sys-fs/eudev
	!sys-fs/udev
	gudev? ( !dev-libs/libgudev )"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND=">=sys-apps/dbus-1.6.8-r1:0[systemd]
	>=sys-apps/hwids-20130717-r1[udev]
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
	ia64? ( >=sys-kernel/linux-headers-3.9 )
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.18 )
	python? ( dev-python/lxml[${PYTHON_USEDEP}] )
	test? ( >=sys-apps/dbus-1.6.8-r1:0 )"

PATCHES=(
	"${FILESDIR}/218-Dont-enable-audit-by-default.patch"
	"${FILESDIR}/218-noclean-tmp.patch"
)

pkg_pretend() {
	local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
		~DEVPTS_MULTIPLE_INSTANCES ~DEVTMPFS ~DMIID ~EPOLL ~FANOTIFY ~FHANDLE
		~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SECCOMP ~SIGNALFD ~SYSFS
		~TIMERFD ~TMPFS_XATTR ~UNIX
		~!FW_LOADER_USER_HELPER ~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
		~!SYSFS_DEPRECATED_V2"

	use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
	kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"

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
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Bug 463376
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die

	# missing in tarball
	cp "${FILESDIR}"/217-systemd-consoled.service.in \
		units/user/systemd-consoled.service.in || die

	autotools-utils_src_prepare
}

src_configure() {
	# Keep using the one where the rules were installed.
	MY_UDEVDIR=$(get_udevdir)
	# Fix systems broken by bug #509454.
	[[ ${MY_UDEVDIR} ]] || MY_UDEVDIR=/lib/udev

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		# disable -flto since it is an optimization flag
		# and makes distcc less effective
		cc_cv_CFLAGS__flto=no

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
		$(multilib_native_use_enable doc gtk-doc)
		$(multilib_native_use_enable elfutils)
		$(use_enable gcrypt)
		$(use_enable gudev)
		$(multilib_native_use_enable http microhttpd)
		$(usex http $(multilib_native_use_enable ssl gnutls) --disable-gnutls)
		$(multilib_native_use_enable idn libidn)
		$(multilib_native_use_enable introspection)
		$(use_enable kdbus)
		$(multilib_native_use_enable kmod)
		$(use_enable lz4)
		$(use_enable lzma xz)
		$(multilib_native_use_enable pam)
		$(multilib_native_use_enable policykit polkit)
		$(multilib_native_use_with python)
		$(multilib_native_use_enable python python-devel)
		$(multilib_native_use_enable qrcode qrencode)
		$(multilib_native_use_enable seccomp)
		$(multilib_native_use_enable selinux)
		$(multilib_native_use_enable terminal)
		$(multilib_native_use_enable test tests)
		$(multilib_native_use_enable test dbus)
		$(multilib_native_use_enable xkb xkbcommon)

		# not supported (avoid automagic deps in the future)
		--disable-chkconfig

		# hardcode a few paths to spare some deps
		QUOTAON=/usr/sbin/quotaon
		QUOTACHECK=/usr/sbin/quotacheck

		# dbus paths
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d"
		--with-dbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		--with-dbussystemservicedir="${EPREFIX}/usr/share/dbus-1/system-services"
		--with-dbusinterfacedir="${EPREFIX}/usr/share/dbus-1/interfaces"

		--with-ntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"
	)

	if ! multilib_is_native_abi; then
		myeconfargs+=(
			MOUNT_{CFLAGS,LIBS}=' '

			ac_cv_search_cap_init=
			ac_cv_header_sys_capability_h=yes
		)
	fi

	# Work around bug 463846.
	tc-export CC

	autotools-utils_src_configure
}

multilib_src_compile() {
	local mymakeopts=(
		udevlibexecdir="${MY_UDEVDIR}"
	)

	if multilib_is_native_abi; then
		emake "${mymakeopts[@]}"
	else
		# prerequisites for gudev
		use gudev && emake src/gudev/gudev{enumtypes,marshal}.{c,h}

		echo 'gentoo: $(BUILT_SOURCES)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
		echo 'gentoo: $(lib_LTLIBRARIES) $(pkgconfiglib_DATA)' | \
		emake "${mymakeopts[@]}" -f Makefile -f - gentoo
	fi
}

multilib_src_test() {
	multilib_is_native_abi || continue

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
			install-libgudev_includeHEADERS
			install-pkgincludeHEADERS
		)

		emake "${mymakeopts[@]}"
	fi

	# install compat pkg-config files
	# Change dbus to >=sys-apps/dbus-1.8.8 if/when this is dropped.
	local pcfiles=( src/compat-libs/libsystemd-{daemon,id128,journal,login}.pc )
	emake "${mymakeopts[@]}" install-pkgconfiglibDATA \
		pkgconfiglib_DATA="${pcfiles[*]}"
}

multilib_src_install_all() {
	prune_libtool_files --modules
	einstalldocs

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

	# Disable storing coredumps in journald, bug #433457
	mv "${D}"/usr/lib/sysctl.d/50-coredump.conf{,.disabled} || die

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/binfmt.d /etc/modules-load.d /etc/tmpfiles.d \
		/etc/systemd/ntp-units.d /etc/systemd/user /var/lib/systemd \
		/var/log/journal/remote

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	# If we install these symlinks, there is no way for the sysadmin to remove them
	# permanently.
	rm "${D}"/etc/systemd/system/multi-user.target.wants/systemd-networkd.service || die
	rm "${D}"/etc/systemd/system/multi-user.target.wants/systemd-resolved.service || die
	rm -r "${D}"/etc/systemd/system/network-online.target.wants || die
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

migrate_net_name_slot() {
	# If user has disabled 80-net-name-slot.rules using a empty file or a symlink to /dev/null,
	# do the same for 80-net-setup-link.rules to keep the old behavior
	local net_move=no
	local net_name_slot_sym=no
	local net_rules_path="${EROOT%/}"/etc/udev/rules.d
	local net_name_slot="${net_rules_path}"/80-net-name-slot.rules
	local net_setup_link="${net_rules_path}"/80-net-setup-link.rules
	if [[ -e ${net_setup_link} ]]; then
		net_move=no
	elif [[ -f ${net_name_slot} && $(sed -e "/^#/d" -e "/^\W*$/d" ${net_name_slot} | wc -l) == 0 ]]; then
		net_move=yes
	elif [[ -L ${net_name_slot} && $(readlink ${net_name_slot}) == /dev/null ]]; then
		net_move=yes
		net_name_slot_sym=yes
	fi
	if [[ ${net_move} == yes ]]; then
		ebegin "Copying ${net_name_slot} to ${net_setup_link}"

		if [[ ${net_name_slot_sym} == yes ]]; then
			ln -nfs /dev/null "${net_setup_link}"
		else
			cp "${net_name_slot}" "${net_setup_link}"
		fi
		eend $? || FAIL=1
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
	newusergroup systemd-journal-gateway
	newusergroup systemd-journal-remote
	newusergroup systemd-journal-upload
	newusergroup systemd-network
	newusergroup systemd-resolve
	newusergroup systemd-timesync
	use http && newusergroup systemd-journal-gateway

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

	# Migrate 80-net-name-slot.rules -> 80-net-setup-link.rules
	migrate_net_name_slot

	if [[ ${FAIL} ]]; then
		eerror "One of the postinst commands failed. Please check the postinst output"
		eerror "for errors. You may need to clean up your system and/or try installing"
		eerror "systemd again."
		eerror
	fi

	if [[ $(readlink "${ROOT}"/etc/resolv.conf) == */run/systemd/network/resolv.conf ]]; then
		ewarn "resolv.conf is now generated by systemd-resolved. To use it, enable"
		ewarn "systemd-resolved.service, and create a symlink from /etc/resolv.conf"
		ewarn "to /run/systemd/resolve/resolv.conf"
		ewarn
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
