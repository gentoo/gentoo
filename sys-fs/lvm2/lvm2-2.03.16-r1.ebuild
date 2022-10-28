# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TMPFILES_OPTIONAL=1
inherit autotools linux-info systemd toolchain-funcs tmpfiles udev flag-o-matic

DESCRIPTION="User-land utilities for LVM2 (device-mapper) software"
HOMEPAGE="https://sourceware.org/lvm2/"
SRC_URI="https://sourceware.org/ftp/lvm2/${PN^^}.${PV}.tgz"
S="${WORKDIR}/${PN^^}.${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+lvm lvm2create-initrd readline sanlock selinux static static-libs systemd +thin +udev"
REQUIRED_USE="
	static? ( !systemd !udev )
	static-libs? ( static !udev )
	systemd? ( udev )"

DEPEND_COMMON="
	udev? ( virtual/libudev:= )
	lvm? (
		dev-libs/libaio
		sys-apps/util-linux
		readline? ( sys-libs/readline:= )
		sanlock? ( sys-cluster/sanlock )
		systemd? ( sys-apps/systemd:= )
	)"
# /run is now required for locking during early boot. /var cannot be assumed to
# be available -- thus, pull in recent enough baselayout for /run.
# This version of LVM is incompatible with cryptsetup <1.1.2.
RDEPEND="${DEPEND_COMMON}
	>=sys-apps/baselayout-2.2
	lvm? (
		virtual/tmpfiles
		lvm2create-initrd? ( sys-apps/makedev )
		thin? ( sys-block/thin-provisioning-tools )
	)"
# note: thin- 0.3.0 is required to avoid --disable-thin_check_needs_check
DEPEND="${DEPEND_COMMON}
	static? (
		lvm? (
			dev-libs/libaio[static-libs]
			sys-apps/util-linux[static-libs]
			readline? ( sys-libs/readline[static-libs] )
		)
		selinux? ( sys-libs/libselinux[static-libs] )
	)"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig"

PATCHES=(
	# Gentoo specific modification(s):
	"${FILESDIR}"/${PN}-2.03.06-example.conf.in.patch

	# For upstream -- review and forward:
	"${FILESDIR}"/${PN}-2.02.56-lvm2create_initrd.patch
	"${FILESDIR}"/${PN}-2.02.67-createinitrd.patch #301331
	"${FILESDIR}"/${PN}-2.02.99-locale-muck.patch #330373
	"${FILESDIR}"/${PN}-2.03.12-dynamic-static-ldflags.patch #332905
	"${FILESDIR}"/${PN}-2.03.14-static-pkgconfig-libs.patch #370217, #439414 + blkid
	"${FILESDIR}"/${PN}-2.03.12-static-pkgconfig-libs-2.patch
	"${FILESDIR}"/${PN}-2.03.05-pthread-pkgconfig.patch #492450
	"${FILESDIR}"/${PN}-2.03.12-static-libm.patch #617756
	"${FILESDIR}"/${PN}-2.02.166-HPPA-no-O_DIRECT.patch #657446
	"${FILESDIR}"/${PN}-2.03.05-dmeventd-no-idle-exit.patch
	"${FILESDIR}"/${PN}-2.03.14-r1-add-fcntl.patch
	"${FILESDIR}"/${PN}-2.03.14-r1-fopen-to-freopen.patch
	"${FILESDIR}"/${PN}-2.03.14-r1-mallinfo.patch
	"${FILESDIR}"/${PN}-2.03.14-freopen_n2.patch
	"${FILESDIR}"/${PN}-2.03.16-readelf.patch
)

QA_CONFIGURE_OPTIONS="--disable-static"

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

	# Users without systemd get no auto-activation of any logical volume
	if ! use systemd ; then
		eapply "${FILESDIR}"/${PN}-2.03.16-dm_lvm_rules_no_systemd.patch
	fi

	sed -i \
		-e "1iAR = $(tc-getAR)" \
		-e "s:CC ?= @CC@:CC = $(tc-getCC):" \
		make.tmpl.in || die #444082

	sed -i -e '/FLAG/s:-O2::' configure{.ac,} || die #480212

	sed -i -e "s:/usr/bin/true:$(type -P true):" scripts/blk_availability_systemd_red_hat.service.in || die #517514

	# Don't install thin man page when not requested
	if ! use lvm || ! use thin ; then
		sed -i -e 's/^\(MAN7+=.*\) $(LVMTHINMAN) \(.*\)$/\1 \2/' man/Makefile.in || die
	fi

	eautoreconf
}

src_configure() {
	filter-flags -flto

	# Workaround for bug #822210
	tc-ld-disable-gold

	local myeconfargs=()

	# Most of this package does weird stuff.
	# The build options are tristate, and --without is NOT supported
	# options: 'none', 'internal', 'shared'
	myeconfargs+=(
		$(use_enable lvm dmfilemapd)
		$(use_enable lvm dmeventd)
		$(use_enable lvm cmdlib)
		$(use_enable lvm fsadm)
		$(use_enable lvm lvmpolld)
		$(usev !lvm --disable-udev-systemd-background-jobs)

		# This only causes the .static versions to become available
		$(usev static --enable-static_link)

		# dmeventd requires mirrors to be internal, and snapshot available
		# so we cannot disable them
		--with-mirrors="$(usex lvm internal none)"
		--with-snapshots="$(usex lvm internal none)"

		# disable O_DIRECT support on hppa, breaks pv detection (#99532)
		$(usev hppa --disable-o_direct)
	)

	if use lvm && use thin; then
		myeconfargs+=( --with-thin=internal --with-cache=internal )
		local texec
		for texec in check dump repair restore; do
			myeconfargs+=( --with-thin-${texec}="${EPREFIX}"/sbin/thin_${texec} )
			myeconfargs+=( --with-cache-${texec}="${EPREFIX}"/sbin/cache_${texec} )
		done
	else
		myeconfargs+=( --with-thin=none --with-cache=none )
	fi

	export READELF="$(tc-getREADELF)"
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
		$(use_with udev udevdir "${EPREFIX}$(get_udevdir)"/rules.d)
		# USE=sanlock requires USE=lvm
		$(use_enable $(usex lvm sanlock lvm) lvmlockd-sanlock)
		$(use_enable systemd udev-systemd-background-jobs)
		$(use_enable systemd notify-dbus)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		CLDFLAGS="${LDFLAGS}"
		READELF="${READELF}"
	)
	# Hard-wire this to bash as some shells (dash) don't know
	# "-o pipefail" #682404
	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=1 -C include

	if use lvm ; then
		emake V=1
		emake V=1 CC="$(tc-getCC)" -C scripts
	else
		emake V=1 device-mapper
		# https://bugs.gentoo.org/878131
		emake V=1 -C libdm/dm-tools device-mapper
	fi
}

src_test() {
	einfo "Tests are disabled because of device-node mucking, if you want to"
	einfo "run tests, compile the package and see ${S}/tests"
}

src_install() {
	local INSTALL_TARGETS=(
		# full LVM2
		$(usev lvm "install install_tmpfiles_configuration")
		# install systemd related files only when requested, bug #522430
		$(usev $(usex lvm systemd lvm) "SYSTEMD_GENERATOR_DIR=$(systemd_get_systemgeneratordir) install_systemd_units install_systemd_generators")

		# install dm unconditionally
		install_device-mapper
	)
	emake V=1 DESTDIR="${D}" "${INSTALL_TARGETS[@]}"

	newinitd "${FILESDIR}"/device-mapper.rc-2.02.105-r2 device-mapper
	newconfd "${FILESDIR}"/device-mapper.conf-1.02.22-r3 device-mapper

	if use lvm ; then
		newinitd "${FILESDIR}"/dmeventd.initd-2.02.184-r2 dmeventd
		newinitd "${FILESDIR}"/lvm.rc-2.02.187 lvm
		newconfd "${FILESDIR}"/lvm.confd-2.02.184-r3 lvm
		if ! use udev ; then
			# We keep the variable but remove udev from it.
			sed -r -i \
				-e '/^rc_need=/s/\<udev\>//g' \
				"${ED}"/etc/conf.d/lvm || die "Could not drop udev from rc_need"
		fi

		newinitd "${FILESDIR}"/lvm-monitoring.initd-2.02.105-r2 lvm-monitoring
		newinitd "${FILESDIR}"/lvmpolld.initd-2.02.183 lvmpolld

		if use lvm2create-initrd; then
			dosbin scripts/lvm2create_initrd/lvm2create_initrd
			doman scripts/lvm2create_initrd/lvm2create_initrd.8
			newdoc scripts/lvm2create_initrd/README README.lvm2create_initrd
		fi

		if use sanlock; then
			newinitd "${FILESDIR}"/lvmlockd.initd-2.02.166-r1 lvmlockd
		fi
	fi

	if use static-libs; then
		dolib.a libdm/ioctl/libdevmapper.a
		if use lvm; then
			# depends on lvmetad
			dolib.a libdaemon/client/libdaemonclient.a #462908
			# depends on dmeventd
			dolib.a daemons/dmeventd/libdevmapper-event.a
		fi
	else
		rm -f "${ED}"/usr/$(get_libdir)/{libdevmapper-event,liblvm2cmd,liblvm2app,libdevmapper}.a || die
	fi

	insinto /etc
	doins "${FILESDIR}"/dmtab

	dodoc README VERSION* WHATS_NEW WHATS_NEW_DM doc/*.{c,txt} conf/*.conf
}

pkg_postinst() {
	use lvm && tmpfiles_process lvm2.conf

	if use udev; then
		udev_reload
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

pkg_postrm() {
	if use udev && [[ -z ${REPLACED_BY_VERSION} ]]; then
		udev_reload
	fi
}
