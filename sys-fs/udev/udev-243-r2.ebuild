# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 linux-info meson ninja-utils multilib-minimal toolchain-funcs udev usr-ldscript

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	MY_PV=${PV/_/-}
	MY_P=systemd-${MY_PV}
	S=${WORKDIR}/${MY_P}
	SRC_URI="https://github.com/systemd/systemd/archive/v${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl +kmod selinux static-libs"

RESTRICT="test"

COMMON_DEPEND=">=sys-apps/util-linux-2.30[${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	acl? ( sys-apps/acl )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!<sys-libs/glibc-2.11
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd"
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=dev-util/meson-0.40.0
	dev-util/ninja
	>=sys-apps/coreutils-8.16
	virtual/os-headers
	virtual/pkgconfig
	>=sys-kernel/linux-headers-3.9
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"
RDEPEND="${COMMON_DEPEND}
	acct-group/kmem
	acct-group/tty
	acct-group/audio
	acct-group/cdrom
	acct-group/dialout
	acct-group/disk
	acct-group/input
	acct-group/kvm
	acct-group/lp
	acct-group/render
	acct-group/tape
	acct-group/video
	!<sys-fs/lvm2-2.02.103
	!<sec-policy/selinux-base-2.20120725-r10"
PDEPEND=">=sys-apps/hwids-20140304[udev]
	>=sys-fs/udev-init-scripts-26"

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~!FW_LOADER_USER_HELPER ~UNIX"
		linux-info_pkg_setup

		# CONFIG_FHANDLE was introduced by 2.6.39
		local MINKV=2.6.39

		if kernel_is -lt ${MINKV//./ }; then
			eerror "Your running kernel is too old to run this version of ${P}"
			eerror "You need to upgrade kernel at least to ${MINKV}"
		fi

		if kernel_is -lt 3 7; then
			ewarn "Your running kernel is too old to have firmware loader and"
			ewarn "this version of ${P} doesn't have userspace firmware loader"
			ewarn "If you need firmware support, you need to upgrade kernel at least to 3.7"
		fi
	fi
}

src_prepare() {
	cat <<-EOF > "${T}"/40-gentoo.rules
	# Gentoo specific floppy and usb groups
	ACTION=="add", SUBSYSTEM=="block", KERNEL=="fd[0-9]", GROUP="floppy"
	ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", GROUP="usb"
	EOF

	if [[ -d "${WORKDIR}/patches" ]]; then
		eapply "${WORKDIR}/patches"
	fi

	default
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dacl=$(meson_multilib_native_use acl)
		-Defi=false
		-Dkmod=$(meson_multilib_native_use kmod)
		-Dselinux=$(meson_multilib_native_use selinux)
		-Dlink-udev-shared=false
		-Dsplit-usr=true
		-Drootlibdir="${EPREFIX}/usr/$(get_libdir)"
		-Dstatic-libudev=$(usex static-libs true false)

		# Prevent automagic deps
		-Dgcrypt=false
		-Dlibcryptsetup=false
		-Dlibidn=false
		-Dlibidn2=false
		-Dlibiptc=false
		-Dseccomp=false
		-Dlz4=false
		-Dxz=false
	)
	meson_src_configure
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB
	multilib-minimal_src_configure
}

multilib_src_compile() {
	# meson creates this link
	local libudev=$(readlink src/udev/libudev.so.1)

	local targets=(
		src/udev/${libudev}
	)
	if use static-libs; then
		targets+=( src/udev/libudev.a )
	fi
	if multilib_is_native_abi; then
		targets+=(
			systemd-udevd
			udevadm
			src/udev/ata_id
			src/udev/cdrom_id
			src/udev/mtd_probe
			src/udev/scsi_id
			src/udev/v4l_id
			man/udev.conf.5
			man/systemd.link.5
			man/hwdb.7
			man/udev.7
			man/systemd-udevd.service.8
			man/udevadm.8
		)
	fi
	eninja "${targets[@]}"
}

multilib_src_install() {
	local libudev=$(readlink src/udev/libudev.so.1)

	dolib.so src/udev/{${libudev},libudev.so.1,libudev.so}
	gen_usr_ldscript -a udev
	use static-libs && dolib.a src/udev/libudev.a

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins src/libudev/libudev.pc

	if multilib_is_native_abi; then
		into /
		dobin udevadm

		exeinto /lib/systemd
		doexe systemd-udevd

		exeinto /lib/udev
		doexe src/udev/{ata_id,cdrom_id,mtd_probe,scsi_id,v4l_id}

		rm rules/99-systemd.rules || die
		insinto /lib/udev/rules.d
		doins rules/*.rules

		insinto /usr/share/pkgconfig
		doins src/udev/udev.pc

		mv man/systemd-udevd.service.8 man/systemd-udevd.8 || die
		rm man/systemd-udevd-{control,kernel}.socket.8 || die
		doman man/*.[0-9]
	fi
}

multilib_src_install_all() {
	doheader src/libudev/libudev.h

	insinto /etc/udev
	doins src/udev/udev.conf
	keepdir /etc/udev/{hwdb.d,rules.d}

	insinto /lib/systemd/network
	doins network/99-default.link

	# see src_prepare() for content of 40-gentoo.rules
	insinto /lib/udev/rules.d
	doins "${T}"/40-gentoo.rules
	doins "${S}"/rules/*.rules

	dobashcomp shell-completion/bash/udevadm

	insinto /usr/share/zsh/site-functions
	doins shell-completion/zsh/_udevadm

	einstalldocs
}

pkg_postinst() {
	mkdir -p "${ROOT%/}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${ROOT%/}"/dev/loop 2>/dev/null
	if [[ -d ${ROOT%/}/dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	local fstab="${ROOT%/}"/etc/fstab dev path fstype rest
	while read -r dev path fstype rest; do
		if [[ ${path} == /dev && ${fstype} != devtmpfs ]]; then
			ewarn "You need to edit your /dev line in ${fstab} to have devtmpfs"
			ewarn "filesystem. Otherwise udev won't be able to boot."
			ewarn "See, https://bugs.gentoo.org/453186"
		fi
	done < "${fstab}"

	if [[ -d ${ROOT%/}/usr/lib/udev ]]; then
		ewarn
		ewarn "Please re-emerge all packages on your system which install"
		ewarn "rules and helpers in /usr/lib/udev. They should now be in"
		ewarn "/lib/udev."
		ewarn
		ewarn "One way to do this is to run the following command:"
		ewarn "emerge -av1 \$(qfile -q -S -C /usr/lib/udev)"
		ewarn "Note that qfile can be found in app-portage/portage-utils"
	fi

	local old_cd_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-cd.rules
	local old_net_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-net.rules
	for old_rules in "${old_cd_rules}" "${old_net_rules}"; do
		if [[ -f ${old_rules} ]]; then
			ewarn
			ewarn "File ${old_rules} is from old udev installation but if you still use it,"
			ewarn "rename it to something else starting with 70- to silence this deprecation"
			ewarn "warning."
		fi
	done

	elog
	elog "Starting from version >= 197 the new predictable network interface names are"
	elog "used by default, see:"
	elog "https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames"
	elog "https://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c"
	elog
	elog "Example command to get the information for the new interface name before booting"
	elog "(replace <ifname> with, for example, eth0):"
	elog "# udevadm test-builtin net_id /sys/class/net/<ifname> 2> /dev/null"
	elog
	elog "You can use either kernel parameter \"net.ifnames=0\", create empty"
	elog "file /etc/systemd/network/99-default.link, or symlink it to /dev/null"
	elog "to disable the feature."

	if has_version 'sys-apps/biosdevname'; then
		ewarn
		ewarn "You can replace the functionality of sys-apps/biosdevname which has been"
		ewarn "detected to be installed with the new predictable network interface names."
	fi

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into effect."
	ewarn "The method you use to do this depends on your init system."
	if has_version 'sys-apps/openrc'; then
		ewarn "For sys-apps/openrc users it is:"
		ewarn "# /etc/init.d/udev --nodeps restart"
	fi

	elog
	elog "For more information on udev on Gentoo, upgrading, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "https://wiki.gentoo.org/wiki/Udev"
	elog "https://wiki.gentoo.org/wiki/Udev/upgrade"

	# If user has disabled 80-net-name-slot.rules using a empty file or a symlink to /dev/null,
	# do the same for 80-net-setup-link.rules to keep the old behavior
	local net_move=no
	local net_name_slot_sym=no
	local net_rules_path="${ROOT%/}"/etc/udev/rules.d
	local net_name_slot="${net_rules_path}"/80-net-name-slot.rules
	local net_setup_link="${net_rules_path}"/80-net-setup-link.rules
	if [[ ! -e ${net_setup_link} ]]; then
		[[ -f ${net_name_slot} && $(sed -e "/^#/d" -e "/^\W*$/d" ${net_name_slot} | wc -l) == 0 ]] && net_move=yes
		if [[ -L ${net_name_slot} && $(readlink ${net_name_slot}) == /dev/null ]]; then
			net_move=yes
			net_name_slot_sym=yes
		fi
	fi
	if [[ ${net_move} == yes ]]; then
		ebegin "Copying ${net_name_slot} to ${net_setup_link}"

		if [[ ${net_name_slot_sym} == yes ]]; then
			ln -nfs /dev/null "${net_setup_link}"
		else
			cp "${net_name_slot}" "${net_setup_link}"
		fi
		eend $?
	fi

	# Update hwdb database in case the format is changed by udev version.
	if has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT%/}"
		# Only reload when we are not upgrading to avoid potential race w/ incompatible hwdb.bin and the running udevd
		# https://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		[[ -z ${REPLACING_VERSIONS} ]] && udev_reload
	fi
}
