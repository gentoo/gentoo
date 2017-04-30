# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit bash-completion-r1 linux-info multilib-minimal multiprocessing pam python-any-r1 systemd toolchain-funcs udev user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
IUSE="acl apparmor audit build cryptsetup curl elfutils +gcrypt gnuefi http
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
	pam? ( virtual/pam:=[${MULTILIB_USEDEP}] )
	qrcode? ( media-gfx/qrencode:0= )
	seccomp? ( >=sys-libs/libseccomp-2.3.1:0= )
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
	!build? ( || (
		sys-apps/util-linux[kill(-)]
		sys-process/procps[kill(+)]
		sys-apps/coreutils[kill(-)]
	) )
	!sys-auth/nss-myhostname
	!<sys-kernel/dracut-044
	!sys-fs/eudev
	!sys-fs/udev"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND=">=sys-apps/dbus-1.9.8[systemd]
	>=sys-apps/hwids-20150417[udev]
	>=sys-fs/udev-init-scripts-25
	policykit? ( sys-auth/polkit )
	!vanilla? ( sys-apps/gentoo-systemd-integration )"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=dev-util/meson-0.40.0
	dev-util/ninja
	>=sys-apps/coreutils-8.16
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig
	gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	test? ( sys-apps/dbus )
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
"

pkg_pretend() {
	local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
		~CHECKPOINT_RESTORE ~DEVTMPFS ~DMIID ~EPOLL ~FANOTIFY ~FHANDLE
		~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
		~TIMERFD ~TMPFS_XATTR ~UNIX
		~CRYPTO_HMAC ~CRYPTO_SHA256 ~CRYPTO_USER_API_HASH
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
	)

	if ! use vanilla; then
		PATCHES+=(
			"${FILESDIR}/218-Dont-enable-audit-by-default.patch"
			"${FILESDIR}/228-noclean-tmp.patch"
			"${FILESDIR}/233-systemd-user-pam.patch"
		)
	fi

	[[ -d "${WORKDIR}"/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	default
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	python_setup

	multilib-minimal_src_configure
}

meson_use() {
	usex "$1" true false
}

meson_multilib() {
	if multilib_is_native_abi; then
		echo true
	else
		echo false
	fi
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local myconf=(
		--buildtype=plain
		--prefix="${EPREFIX}/usr"
		--libdir="$(get_libdir)"
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		-Dpamlibdir="$(getpam_mod_dir)"
		# avoid bash-completion dep
		-Dbashcompletiondir="$(get_bashcompdir)"
		# make sure we get /bin:/sbin in $PATH
		-Dsplit-usr=true
		-Drootprefix="${EPREFIX}${ROOTPREFIX}"
		-Dsysvinit-path=
		-Dsysvrcnd-path=
		# no deps
		-Defi=$(meson_multilib)
		-Dima=true
		# Optional components/dependencies
		-Dacl=$(meson_multilib_native_use acl)
		-Dapparmor=$(meson_multilib_native_use apparmor)
		-Daudit=$(meson_multilib_native_use audit)
		-Dlibcryptsetup=$(meson_multilib_native_use cryptsetup)
		-Dlibcurl=$(meson_multilib_native_use curl)
		-Delfutils=$(meson_multilib_native_use elfutils)
		-Dgcrypt=$(meson_use gcrypt)
		-Dgnu-efi=$(meson_multilib_native_use gnuefi)
		-Defi-libdir="/usr/$(get_libdir)"
		-Dmicrohttpd=$(meson_multilib_native_use http)
		$(usex http -Dgnutls=$(meson_multilib_native_use ssl) -Dgnutls=false)
		-Dlibidn=$(meson_multilib_native_use idn)
		-Dimportd=$(meson_multilib_native_use importd)
		-Dbzip2=$(meson_multilib_native_use importd)
		-Dzlib=$(meson_multilib_native_use importd)
		-Dkmod=$(meson_multilib_native_use kmod)
		-Dlz4=$(meson_use lz4)
		-Dxz=$(meson_use lzma)
		-Dlibiptc=$(meson_multilib_native_use nat)
		-Dpam=$(meson_use pam)
		-Dpolkit=$(meson_multilib_native_use policykit)
		-Dqrencode=$(meson_multilib_native_use qrcode)
		-Dseccomp=$(meson_multilib_native_use seccomp)
		-Dselinux=$(meson_multilib_native_use selinux)
		#-Dtests=$(meson_multilib_native_use test)
		-Ddbus=$(meson_multilib_native_use test)
		-Dxkbcommon=$(meson_multilib_native_use xkb)
		# hardcode a few paths to spare some deps
		-Dpath-kill=/bin/kill
		-Dntp-servers="0.gentoo.pool.ntp.org 1.gentoo.pool.ntp.org 2.gentoo.pool.ntp.org 3.gentoo.pool.ntp.org"
		# Breaks screen, tmux, etc.
		-Ddefault-kill-user-processes=false

		# multilib options
		-Dbacklight=$(meson_multilib)
		-Dbinfmt=$(meson_multilib)
		-Dcoredump=$(meson_multilib)
		-Denvironment-d=$(meson_multilib)
		-Dfirstboot=$(meson_multilib)
		-Dhibernate=$(meson_multilib)
		-Dhostnamed=$(meson_multilib)
		-Dhwdb=$(meson_multilib)
		-Dldconfig=$(meson_multilib)
		-Dlocaled=$(meson_multilib)
		-Dman=$(meson_multilib)
		-Dnetworkd=$(meson_multilib)
		-Dquotacheck=$(meson_multilib)
		-Drandomseed=$(meson_multilib)
		-Drfkill=$(meson_multilib)
		-Dsysysers=$(meson_multilib)
		-Dtimedated=$(meson_multilib)
		-Dtimesyncd=$(meson_multilib)
		-Dtmpfiles=$(meson_multilib)
		-Dvconsole=$(meson_multilib)
	)

	set -- meson "${myconf[@]}" "${S}"
	echo "$@"
	"$@" || die
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j $(makeopts_jobs) -l $(makeopts_loadavg "${MAKEOPTS}" 0)"
	fi
	set -- ninja -v ${NINJAOPTS} "$@"
	echo "$@"
	"$@" || die
}

multilib_src_compile() {
	eninja
}

multilib_src_test() {
	eninja test
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

multilib_src_install_all() {
	# meson doesn't know about docdir
	mv "${ED%/}"/usr/share/doc/{systemd,${PF}} || die

	einstalldocs
	dodoc "${FILESDIR}"/nsswitch.conf

	if use sysv-utils; then
		for app in halt poweroff reboot runlevel shutdown telinit; do
			dosym "..${ROOTPREFIX%/}/bin/systemctl" /sbin/${app}
		done
		dosym "..${ROOTPREFIX%/}/lib/systemd/systemd" /sbin/init
	else
		# we just keep sysvinit tools, so no need for the mans
		rm "${ED%/}"/usr/share/man/man8/{halt,poweroff,reboot,runlevel,shutdown,telinit}.8 \
			|| die
		rm "${ED%/}"/usr/share/man/man1/init.1 || die
	fi

	# Preserve empty dirs in /etc & /var, bug #437008
	keepdir /etc/binfmt.d /etc/modules-load.d /etc/tmpfiles.d \
		/etc/systemd/ntp-units.d /etc/systemd/user /var/lib/systemd \
		/var/log/journal/remote

	# Symlink /etc/sysctl.conf for easy migration.
	dosym ../sysctl.conf /etc/sysctl.d/99-sysctl.conf

	# If we install these symlinks, there is no way for the sysadmin to remove them
	# permanently.
	rm "${ED%/}"/etc/systemd/system/multi-user.target.wants/systemd-networkd.service || die
	rm -f "${ED%/}"/etc/systemd/system/multi-user.target.wants/systemd-resolved.service || die
	rm -r "${ED%/}"/etc/systemd/system/network-online.target.wants || die
	rm -r "${ED%/}"/etc/systemd/system/sockets.target.wants || die
	rm -r "${ED%/}"/etc/systemd/system/sysinit.target.wants || die

	rm -r "${ED%/}${ROOTPREFIX%/}/lib/udev/hwdb.d" || die

	if [[ ! -e "${ED%/}"/usr/lib/systemd/systemd ]]; then
		# Avoid breaking boot/reboot
		dosym "../../..${ROOTPREFIX%/}/lib/systemd/systemd" /usr/lib/systemd/systemd
		dosym "../../..${ROOTPREFIX%/}/lib/systemd/systemd-shutdown" /usr/lib/systemd/systemd-shutdown
	fi
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
		udevadm hwdb --update --root="${EROOT%/}"
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
		ewarn "ln -snf ${ROOTPREFIX%/}/lib/systemd/resolv.conf ${ROOT}etc/resolv.conf"
	fi
}

pkg_prerm() {
	# If removing systemd completely, remove the catalog database.
	if [[ ! ${REPLACED_BY_VERSION} ]]; then
		rm -f -v "${EROOT}"/var/lib/systemd/catalog/database
	fi
}
