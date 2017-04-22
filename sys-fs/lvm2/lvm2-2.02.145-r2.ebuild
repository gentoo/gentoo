# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils linux-info multilib systemd toolchain-funcs udev flag-o-matic

DESCRIPTION="User-land utilities for LVM2 (device-mapper) software"
HOMEPAGE="https://sourceware.org/lvm2/"
SRC_URI="ftp://sourceware.org/pub/lvm2/${PN/lvm/LVM}.${PV}.tgz
	ftp://sourceware.org/pub/lvm2/old/${PN/lvm/LVM}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="readline static static-libs systemd clvm cman corosync lvm1 lvm2create_initrd openais selinux +udev +thin device-mapper-only"
REQUIRED_USE="device-mapper-only? ( !clvm !cman !corosync !lvm1 !lvm2create_initrd !openais !thin )
	systemd? ( udev )
	clvm? ( !systemd )"

DEPEND_COMMON="
	clvm? (
		cman? ( =sys-cluster/cman-3* )
		corosync? ( sys-cluster/corosync )
		openais? ( sys-cluster/openais )
		=sys-cluster/libdlm-3*
	)

	readline? ( sys-libs/readline:0= )
	systemd? ( >=sys-apps/systemd-205:0= )
	udev? ( >=virtual/libudev-208:=[static-libs?] )"
# /run is now required for locking during early boot. /var cannot be assumed to
# be available -- thus, pull in recent enough baselayout for /run.
# This version of LVM is incompatible with cryptsetup <1.1.2.
RDEPEND="${DEPEND_COMMON}
	>=sys-apps/baselayout-2.2
	!<sys-apps/openrc-0.11
	!<sys-fs/cryptsetup-1.1.2
	!!sys-fs/clvm
	!!sys-fs/lvm-user
	>=sys-apps/util-linux-2.16
	lvm2create_initrd? ( sys-apps/makedev )
	thin? ( >=sys-block/thin-provisioning-tools-0.3.0 )"
# note: thin- 0.3.0 is required to avoid --disable-thin_check_needs_check
# USE 'static' currently only works with eudev, bug 520450
DEPEND="${DEPEND_COMMON}
	virtual/pkgconfig
	>=sys-devel/binutils-2.20.1-r1
	sys-devel/autoconf-archive
	static? (
		selinux? ( sys-libs/libselinux[static-libs] )
		udev? ( >=sys-fs/eudev-3.1.2[static-libs] )
		>=sys-apps/util-linux-2.16[static-libs]
	)"

S=${WORKDIR}/${PN/lvm/LVM}.${PV}

PATCHES=(
	# Gentoo specific modification(s):
	"${FILESDIR}"/${PN}-2.02.129-example.conf.in.patch

	# For upstream -- review and forward:
	"${FILESDIR}"/${PN}-2.02.63-always-make-static-libdm.patch
	"${FILESDIR}"/${PN}-2.02.56-lvm2create_initrd.patch
	"${FILESDIR}"/${PN}-2.02.67-createinitrd.patch #301331
	"${FILESDIR}"/${PN}-2.02.99-locale-muck.patch #330373
	"${FILESDIR}"/${PN}-2.02.70-asneeded.patch # -Wl,--as-needed
	"${FILESDIR}"/${PN}-2.02.139-dynamic-static-ldflags.patch #332905
	"${FILESDIR}"/${PN}-2.02.129-static-pkgconfig-libs.patch #370217, #439414 + blkid
	"${FILESDIR}"/${PN}-2.02.130-pthread-pkgconfig.patch #492450
	"${FILESDIR}"/${PN}-2.02.145-mkdev.patch #580062
)

pkg_setup() {
	local CONFIG_CHECK="~SYSVIPC"

	if use udev; then
		local WARNING_SYSVIPC="CONFIG_SYSVIPC:\tis not set (required for udev sync)\n"
		if linux_config_exists; then
			local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [ -n "${uevent_helper_path}" ] && [ "${uevent_helper_path}" != '""' ]; then
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

	sed -i -e '/FLAG/s:-O2::' configure{.in,} || die #480212

	if use udev && ! use device-mapper-only; then
		sed -i -e '/use_lvmetad =/s:0:1:' conf/example.conf.in || die #514196
		elog "Notice that \"use_lvmetad\" setting is enabled with USE=\"udev\" in"
		elog "/etc/lvm/lvm.conf, which will require restart of udev, lvm, and lvmetad"
		elog "if it was previously disabled."
	fi

	sed -i -e "s:/usr/bin/true:$(type -P true):" scripts/blk_availability_systemd_red_hat.service.in || die #517514

	# Without thin-privision-tools, there is nothing to install for target install_man7:
	use thin || { sed -i -e '/^install_lvm2/s:install_man7::' man/Makefile.in || die; }

	eautoreconf
}

src_configure() {
	filter-flags -flto
	local myconf=()
	local buildmode

	myconf+=( $(use_enable !device-mapper-only dmeventd) )
	myconf+=( $(use_enable !device-mapper-only cmdlib) )
	myconf+=( $(use_enable !device-mapper-only applib) )
	myconf+=( $(use_enable !device-mapper-only fsadm) )
	myconf+=( $(use_enable !device-mapper-only lvmetad) )
	use device-mapper-only && myconf+=( --disable-udev-systemd-background-jobs )

	# Most of this package does weird stuff.
	# The build options are tristate, and --without is NOT supported
	# options: 'none', 'internal', 'shared'
	if use static; then
		buildmode="internal"
		# This only causes the .static versions to become available
		myconf+=( --enable-static_link )
	else
		buildmode="shared"
	fi
	dmbuildmode=$(use !device-mapper-only && echo internal || echo none)

	# dmeventd requires mirrors to be internal, and snapshot available
	# so we cannot disable them
	myconf+=( --with-mirrors=${dmbuildmode} )
	myconf+=( --with-snapshots=${dmbuildmode} )
	if use thin; then
		myconf+=( --with-thin=internal --with-cache=internal )
		local texec
		for texec in check dump repair restore; do
			myconf+=( --with-thin-${texec}="${EPREFIX}"/sbin/thin_${texec} )
			myconf+=( --with-cache-${texec}="${EPREFIX}"/sbin/cache_${texec} )
		done
	else
		myconf+=( --with-thin=none --with-cache=none )
	fi

	if use lvm1; then
		myconf+=( --with-lvm1=${buildmode} )
	else
		myconf+=( --with-lvm1=none )
	fi

	# disable O_DIRECT support on hppa, breaks pv detection (#99532)
	use hppa && myconf+=( --disable-o_direct )

	if use clvm; then
		myconf+=( --with-cluster=${buildmode} )
		# 4-state! Make sure we get it right, per bug 210879
		# Valid options are: none, cman, gulm, all
		#
		# 2009/02:
		# gulm is removed now, now dual-state:
		# cman, none
		# all still exists, but is not needed
		#
		# 2009/07:
		# TODO: add corosync and re-enable ALL
		local clvmd=""
		use cman && clvmd="cman"
		#clvmd="${clvmd/cmangulm/all}"
		use corosync && clvmd="${clvmd:+$clvmd,}corosync"
		use openais && clvmd="${clvmd:+$clvmd,}openais"
		[ -z "${clvmd}" ] && clvmd="none"
		myconf+=( --with-clvmd=${clvmd} )
		myconf+=( --with-pool=${buildmode} )
	else
		myconf+=( --with-clvmd=none --with-cluster=none )
	fi

	econf \
		$(use_enable readline) \
		$(use_enable selinux) \
		--enable-pkgconfig \
		--with-confdir="${EPREFIX}"/etc \
		--exec-prefix="${EPREFIX}" \
		--sbindir="${EPREFIX}/sbin" \
		--with-staticdir="${EPREFIX}"/sbin \
		--libdir="${EPREFIX}/$(get_libdir)" \
		--with-usrlibdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-default-dm-run-dir=/run \
		--with-default-run-dir=/run/lvm \
		--with-default-locking-dir=/run/lock/lvm \
		--with-default-pid-dir=/run \
		$(use_enable udev udev_rules) \
		$(use_enable udev udev_sync) \
		$(use_with udev udevdir "$(get_udevdir)"/rules.d) \
		$(use_enable systemd udev-systemd-background-jobs) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		${myconf[@]} \
		CLDFLAGS="${LDFLAGS}"
}

src_compile() {
	pushd include >/dev/null
	emake
	popd >/dev/null

	if use device-mapper-only ; then
		emake device-mapper
	else
		emake
		emake CC="$(tc-getCC)" -C scripts lvm2_activation_generator_systemd_red_hat
	fi
}

src_install() {
	local inst
	INSTALL_TARGETS="install install_tmpfiles_configuration"
	# install systemd related files only when requested, bug #522430
	use systemd && INSTALL_TARGETS="${INSTALL_TARGETS} install_systemd_units install_systemd_generators"
	use device-mapper-only && INSTALL_TARGETS="install_device-mapper"
	for inst in ${INSTALL_TARGETS}; do
		emake DESTDIR="${D}" ${inst}
	done

	newinitd "${FILESDIR}"/device-mapper.rc-2.02.105-r2 device-mapper
	newconfd "${FILESDIR}"/device-mapper.conf-1.02.22-r3 device-mapper

	if use !device-mapper-only ; then
		newinitd "${FILESDIR}"/dmeventd.initd-2.02.67-r1 dmeventd
		newinitd "${FILESDIR}"/lvm.rc-2.02.116-r6 lvm
		newconfd "${FILESDIR}"/lvm.confd-2.02.28-r2 lvm

		newinitd "${FILESDIR}"/lvm-monitoring.initd-2.02.105-r2 lvm-monitoring
		newinitd "${FILESDIR}"/lvmetad.initd-2.02.116-r3 lvmetad
	fi

	if use clvm; then
		newinitd "${FILESDIR}"/clvmd.rc-2.02.39 clvmd
		newconfd "${FILESDIR}"/clvmd.confd-2.02.39 clvmd
	fi

	if use static-libs; then
		dolib.a libdm/ioctl/libdevmapper.a
		dolib.a libdaemon/client/libdaemonclient.a #462908
		#gen_usr_ldscript libdevmapper.so
		dolib.a daemons/dmeventd/libdevmapper-event.a
		#gen_usr_ldscript libdevmapper-event.so
	else
		rm -f "${ED}"usr/$(get_libdir)/{libdevmapper-event,liblvm2cmd,liblvm2app,libdevmapper}.a
	fi

	if use lvm2create_initrd; then
		dosbin scripts/lvm2create_initrd/lvm2create_initrd
		doman scripts/lvm2create_initrd/lvm2create_initrd.8
		newdoc scripts/lvm2create_initrd/README README.lvm2create_initrd
	fi

	insinto /etc
	doins "${FILESDIR}"/dmtab

	dodoc README VERSION* WHATS_NEW WHATS_NEW_DM doc/*.{c,txt} conf/*.conf
}

pkg_postinst() {
	ewarn "Make sure the \"lvm\" init script is in the runlevels:"
	ewarn "# rc-update add lvm boot"
	ewarn
	ewarn "Make sure to enable lvmetad in /etc/lvm/lvm.conf if you want"
	ewarn "to enable lvm autoactivation and metadata caching."
}

src_test() {
	einfo "Tests are disabled because of device-node mucking, if you want to"
	einfo "run tests, compile the package and see ${S}/tests"
}
