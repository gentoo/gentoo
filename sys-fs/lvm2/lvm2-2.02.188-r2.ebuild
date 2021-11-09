# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
TMPFILES_OPTIONAL=1
inherit autotools linux-info systemd toolchain-funcs tmpfiles udev flag-o-matic

DESCRIPTION="User-land utilities for LVM2 (device-mapper) software"
HOMEPAGE="https://sourceware.org/lvm2/"
SRC_URI="ftp://sourceware.org/pub/lvm2/${PN/lvm/LVM}.${PV}.tgz
	ftp://sourceware.org/pub/lvm2/old/${PN/lvm/LVM}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="readline static static-libs systemd lvm2create-initrd sanlock selinux +udev +thin device-mapper-only"
REQUIRED_USE="device-mapper-only? ( !lvm2create-initrd !sanlock !thin )
	static? ( !systemd !udev )
	static-libs? ( !udev )
	systemd? ( udev )"

DEPEND_COMMON="
	dev-libs/libaio[static-libs?]
	static? ( dev-libs/libaio[static-libs] )
	!static? ( dev-libs/libaio[static-libs?] )
	readline? ( sys-libs/readline:0= )
	sanlock? ( sys-cluster/sanlock )
	systemd? ( >=sys-apps/systemd-205:0= )
	udev? ( >=virtual/libudev-208:= )"
# /run is now required for locking during early boot. /var cannot be assumed to
# be available -- thus, pull in recent enough baselayout for /run.
# This version of LVM is incompatible with cryptsetup <1.1.2.
RDEPEND="${DEPEND_COMMON}
	>=sys-apps/baselayout-2.2
	!<sys-apps/openrc-0.11
	!<sys-fs/cryptsetup-1.1.2
	!!sys-fs/lvm-user
	>=sys-apps/util-linux-2.16
	lvm2create-initrd? ( sys-apps/makedev )
	!device-mapper-only? ( virtual/tmpfiles )
	thin? ( >=sys-block/thin-provisioning-tools-0.3.0 )"
# note: thin- 0.3.0 is required to avoid --disable-thin_check_needs_check
DEPEND="${DEPEND_COMMON}
	static? (
		selinux? ( sys-libs/libselinux[static-libs] )
		>=sys-apps/util-linux-2.16[static-libs]
	)"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

S="${WORKDIR}/${PN/lvm/LVM}.${PV}"

PATCHES=(
	# Gentoo specific modification(s):
	"${FILESDIR}"/${PN}-2.02.178-example.conf.in.patch

	# For upstream -- review and forward:
	"${FILESDIR}"/${PN}-2.02.63-always-make-static-libdm.patch
	"${FILESDIR}"/${PN}-2.02.56-lvm2create_initrd.patch
	"${FILESDIR}"/${PN}-2.02.67-createinitrd.patch #301331
	"${FILESDIR}"/${PN}-2.02.99-locale-muck.patch #330373
	"${FILESDIR}"/${PN}-2.02.178-asneeded.patch # -Wl,--as-needed
	"${FILESDIR}"/${PN}-2.02.178-dynamic-static-ldflags.patch #332905
	"${FILESDIR}"/${PN}-2.02.178-static-pkgconfig-libs.patch #370217, #439414 + blkid
	"${FILESDIR}"/${PN}-2.02.176-pthread-pkgconfig.patch #492450
	"${FILESDIR}"/${PN}-2.02.171-static-libm.patch #617756
	"${FILESDIR}"/${PN}-2.02.166-HPPA-no-O_DIRECT.patch #657446
	#"${FILESDIR}"/${PN}-2.02.145-mkdev.patch #580062 # Merged upstream
	"${FILESDIR}"/${PN}-2.02.184-dmeventd-no-idle-exit.patch
	#"${FILESDIR}"/${PN}-2.02.184-allow-reading-metadata-with-invalid-creation_time.patch #682380 # merged upstream
	"${FILESDIR}"/${PN}-2.02.184-mksh_build.patch #686652
	"${FILESDIR}"/${PN}-2.02.186-udev_remove_unsupported_option.patch #700160
)

pkg_setup() {
	local CONFIG_CHECK="~SYSVIPC"

	if use udev; then
		local WARNING_SYSVIPC="CONFIG_SYSVIPC:\tis not set (required for udev sync)\n"
		if linux_config_exists; then
			local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [[ -n "${uevent_helper_path}" ]] && [[ "${uevent_helper_path}" != '""' ]]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
		fi
	fi

	check_extra_config

	# 1. Genkernel no longer copies /sbin/lvm blindly.
	if use static; then
		elog "Warning, we no longer overwrite /sbin/lvm and /sbin/dmsetup with"
		elog "their static versions. If you need the static binaries,"
		elog "you must append .static to the filename!"
	fi
}

src_prepare() {
	default

	sed -i \
		-e "1iAR = $(tc-getAR)" \
		-e "s:CC ?= @CC@:CC = $(tc-getCC):" \
		make.tmpl.in || die #444082

	sed -i -e '/FLAG/s:-O2::' configure{.ac,} || die #480212

	if use udev && ! use device-mapper-only; then
		sed -i -e '/use_lvmetad =/s:0:1:' conf/example.conf.in || die #514196
		elog "Notice that \"use_lvmetad\" setting is enabled with USE=\"udev\" in"
		elog "/etc/lvm/lvm.conf, which will require restart of udev, lvm, and lvmetad"
		elog "if it was previously disabled."
	fi

	sed -i -e "s:/usr/bin/true:$(type -P true):" scripts/blk_availability_systemd_red_hat.service.in || die #517514

	# Don't install thin man page when not requested
	if ! use thin ; then
		sed -i -e 's/^\(MAN7+=.*\) $(LVMTHINMAN) \(.*\)$/\1 \2/' man/Makefile.in || die
	fi

	eautoreconf
}

src_configure() {
	filter-flags -flto
	local myeconfargs=()

	# Most of this package does weird stuff.
	# The build options are tristate, and --without is NOT supported
	# options: 'none', 'internal', 'shared'
	myeconfargs+=(
		$(use_enable !device-mapper-only dmfilemapd)
		$(use_enable !device-mapper-only dmeventd)
		$(use_enable !device-mapper-only cmdlib)
		$(use_enable !device-mapper-only applib)
		$(use_enable !device-mapper-only fsadm)
		$(use_enable !device-mapper-only lvmetad)
		$(use_enable !device-mapper-only lvmpolld)
		$(usex device-mapper-only --disable-udev-systemd-background-jobs '')

		# This only causes the .static versions to become available
		$(usex static --enable-static_link '')

		# dmeventd requires mirrors to be internal, and snapshot available
		# so we cannot disable them
		--with-mirrors="$(usex device-mapper-only none internal)"
		--with-snapshots="$(usex device-mapper-only none internal)"

		# disable O_DIRECT support on hppa, breaks pv detection (#99532)
		$(usex hppa --disable-o_direct '')
	)

	if use thin; then
		myeconfargs+=( --with-thin=internal --with-cache=internal )
		local texec
		for texec in check dump repair restore; do
			myeconfargs+=( --with-thin-${texec}="${EPREFIX}"/sbin/thin_${texec} )
			myeconfargs+=( --with-cache-${texec}="${EPREFIX}"/sbin/cache_${texec} )
		done
	else
		myeconfargs+=( --with-thin=none --with-cache=none )
	fi

	myeconfargs+=( --with-clvmd=none --with-cluster=none )

	myeconfargs+=(
		$(use_enable readline)
		$(use_enable selinux)
		--enable-pkgconfig
		--with-confdir="${EPREFIX}"/etc
		--exec-prefix="${EPREFIX}"
		--sbindir="${EPREFIX}/sbin"
		--with-staticdir="${EPREFIX}"/sbin
		--libdir="${EPREFIX}/$(get_libdir)"
		--with-usrlibdir="${EPREFIX}/usr/$(get_libdir)"
		--with-default-dm-run-dir=/run
		--with-default-run-dir=/run/lvm
		--with-default-locking-dir=/run/lock/lvm
		--with-default-pid-dir=/run
		$(use_enable udev udev_rules)
		$(use_enable udev udev_sync)
		$(use_with udev udevdir "$(get_udevdir)"/rules.d)
		$(use_enable sanlock lvmlockd-sanlock)
		$(use_enable systemd udev-systemd-background-jobs)
		$(use_enable systemd notify-dbus)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		CLDFLAGS="${LDFLAGS}"
	)
	# Hard-wire this to bash as some shells (dash) don't know
	# "-o pipefail" #682404
	CONFIG_SHELL="/bin/bash" \
	econf "${myeconfargs[@]}"
}

src_compile() {
	pushd include >/dev/null
	emake V=1
	popd >/dev/null

	if use device-mapper-only ; then
		emake V=1 device-mapper
	else
		emake V=1
		emake V=1 CC="$(tc-getCC)" -C scripts lvm2_activation_generator_systemd_red_hat
	fi
}

src_install() {
	local inst INSTALL_TARGETS
	INSTALL_TARGETS=( install install_tmpfiles_configuration )
	# install systemd related files only when requested, bug #522430
	use systemd && INSTALL_TARGETS+=( install_systemd_units install_systemd_generators )
	use device-mapper-only && INSTALL_TARGETS=( install_device-mapper )
	for inst in ${INSTALL_TARGETS[@]}; do
		emake V=1 DESTDIR="${D}" ${inst}
	done

	newinitd "${FILESDIR}"/device-mapper.rc-2.02.105-r2 device-mapper
	newconfd "${FILESDIR}"/device-mapper.conf-1.02.22-r3 device-mapper

	if use !device-mapper-only ; then
		newinitd "${FILESDIR}"/dmeventd.initd-2.02.184-r2 dmeventd
		newinitd "${FILESDIR}"/lvm.rc-2.02.187 lvm
		newconfd "${FILESDIR}"/lvm.confd-2.02.184-r3 lvm
		if ! use udev ; then
			# We keep the variable but remove udev from it.
			sed -r -i \
				-e '/^rc_need=/s/\<udev\>//g' \
				"${ED}/etc/conf.d/lvm" || die "Could not drop udev from rc_need"
		fi

		newinitd "${FILESDIR}"/lvm-monitoring.initd-2.02.105-r2 lvm-monitoring
		newinitd "${FILESDIR}"/lvmetad.initd-2.02.116-r3 lvmetad
		newinitd "${FILESDIR}"/lvmpolld.initd-2.02.183 lvmpolld
	fi

	if use sanlock; then
		newinitd "${FILESDIR}"/lvmlockd.initd-2.02.166-r1 lvmlockd
	fi

	if use static-libs; then
		dolib.a libdm/ioctl/libdevmapper.a
		if use !device-mapper-only; then
			# depends on lvmetad
			dolib.a libdaemon/client/libdaemonclient.a #462908
			# depends on dmeventd
			dolib.a daemons/dmeventd/libdevmapper-event.a
		fi
	else
		rm -f "${ED}"/usr/$(get_libdir)/{libdevmapper-event,liblvm2cmd,liblvm2app,libdevmapper}.a
	fi

	if use lvm2create-initrd; then
		dosbin scripts/lvm2create_initrd/lvm2create_initrd
		doman scripts/lvm2create_initrd/lvm2create_initrd.8
		newdoc scripts/lvm2create_initrd/README README.lvm2create_initrd
	fi

	insinto /etc
	doins "${FILESDIR}"/dmtab

	dodoc README VERSION* WHATS_NEW WHATS_NEW_DM doc/*.{c,txt} conf/*.conf
}

pkg_postinst() {
	if ! use device-mapper-only; then
		tmpfiles_process lvm2.conf
	fi

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		ewarn "Make sure the \"lvm\" init script is in the runlevels:"
		ewarn "# rc-update add lvm boot"
		ewarn
		ewarn "Make sure to enable lvmetad in /etc/lvm/lvm.conf if you want"
		ewarn "to enable lvm autoactivation and metadata caching."
	fi

	if use udev && [[ -d /run ]] ; then
		local permission_run_expected="drwxr-xr-x"
		local permission_run=$(stat -c "%A" /run)
		if [[ "${permission_run}" != "${permission_run_expected}" ]] ; then
			ewarn "Found the following problematic permissions:"
			ewarn ""
			ewarn "    ${permission_run} /run"
			ewarn ""
			ewarn "Expected:"
			ewarn ""
			ewarn "    ${permission_run_expected} /run"
			ewarn ""
			ewarn "This is known to be causing problems for UDEV-enabled LVM services."
		fi
	fi
}

src_test() {
	einfo "Tests are disabled because of device-node mucking, if you want to"
	einfo "run tests, compile the package and see ${S}/tests"
}
