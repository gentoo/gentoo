# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit bash-completion-r1 eutils linux-info multilib systemd

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="http://dracut.wiki.kernel.org"
SRC_URI="mirror://kernel/linux/utils/boot/${PN}/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug selinux systemd"

RESTRICT="test"

CDEPEND="virtual/udev
	systemd? ( >=sys-apps/systemd-199 )
	"
RDEPEND="${CDEPEND}
	app-arch/cpio
	>=app-shells/bash-4.0
	>sys-apps/kmod-5[tools]
	|| (
		>=sys-apps/sysvinit-2.87-r3
		sys-apps/systemd[sysv-utils]
		sys-apps/systemd-sysv-utils
	)
	>=sys-apps/util-linux-2.21

	debug? ( dev-util/strace )
	selinux? (
		sys-libs/libselinux
		sys-libs/libsepol
		sec-policy/selinux-dracut
	)
	"
DEPEND="${CDEPEND}
	app-text/asciidoc
	>=dev-libs/libxslt-1.1.26
	app-text/docbook-xml-dtd:4.5
	>=app-text/docbook-xsl-stylesheets-1.75.2
	virtual/pkgconfig
	"

DOCS=( AUTHORS HACKING NEWS README README.generic README.kernel README.modules
	README.testsuite TODO )
MY_LIBDIR=/usr/lib
PATCHES=(
	"${FILESDIR}/${PV}-0001-Use-the-same-paths-in-dracut.sh-as-tho.patch"
	"${FILESDIR}/${PV}-0002-Install-dracut-install-and-skipcpio-in.patch"
	"${FILESDIR}/${PV}-0003-Take-into-account-lib64-dirs-when-dete.patch"
	"${FILESDIR}/${PV}-0004-Portability-fixes.patch"
	"${FILESDIR}/${PV}-0005-base-dracut-lib.sh-remove-bashism.patch"
	)
QA_MULTILIB_PATHS="
	usr/lib/dracut/dracut-install
	usr/lib/dracut/skipcpio
	"

#
# Helper functions
#

# Removes module from modules.d.
# $1 = module name
# Module name can be specified without number prefix.
rm_module() {
	local force m
	[[ $1 = -f ]] && force=-f

	for m in $@; do
		if [[ $m =~ ^[0-9][0-9][^\ ]*$ ]]; then
			rm ${force} --interactive=never -r "${modules_dir}"/$m
		else
			rm ${force} --interactive=never -r "${modules_dir}"/[0-9][0-9]$m
		fi
	done
}

# Grabbed from net-misc/netctl ebuild.
optfeature() {
	local desc=$1
	shift
	while (( $# )); do
		if has_version "$1"; then
			elog "  [I] $1 to ${desc}"
		else
			elog "  [ ] $1 to ${desc}"
		fi
		shift
	done
}

#
# ebuild functions
#

src_prepare() {
	epatch "${PATCHES[@]}"

	local libdirs="/$(get_libdir) /usr/$(get_libdir)"
	if [[ ${SYMLINK_LIB} = yes ]]; then
		# Preserve lib -> lib64 symlinks in initramfs
		[[ $libdirs =~ /lib\  ]] || libdirs+=" /lib /usr/lib"
	fi
	einfo "Setting libdirs to \"${libdirs}\" ..."
	sed -e "3alibdirs=\"${libdirs}\"" \
		-i "${S}/dracut.conf.d/gentoo.conf.example" || die

	local udevdir="$("$(tc-getPKG_CONFIG)" udev --variable=udevdir)"
	einfo "Setting udevdir to ${udevdir}..."
	sed -r -e "s|^(udevdir=).*$|\1${udevdir}|" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die

	if use systemd; then
		local systemdutildir="$(systemd_get_utildir)"
		local systemdsystemunitdir="$(systemd_get_unitdir)"
		local systemdsystemconfdir="$("$(tc-getPKG_CONFIG)" systemd \
			--variable=systemdsystemconfdir)"
		[[ ${systemdsystemconfdir} ]] \
			|| systemdsystemconfdir=/etc/systemd/system
		einfo "Setting systemdutildir to ${systemdutildir} and ..."
		sed -e "5asystemdutildir=\"${systemdutildir}\"" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die
		einfo "Setting systemdsystemunitdir to ${systemdsystemunitdir} and..."
		sed -e "6asystemdsystemunitdir=\"${systemdsystemunitdir}\"" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die
		einfo "Setting systemdsystemconfdir to ${systemdsystemconfdir}..."
		sed -e "7asystemdsystemconfdir=\"${systemdsystemconfdir}\"" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die
	else
		local systemdutildir="/lib/systemd"
		einfo "Setting systemdutildir for standalone udev to" \
			"${systemdutildir}..."
		sed -e "5asystemdutildir=\"${systemdutildir}\"" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die
	fi

	epatch_user
}

src_configure() {
	local myconf="--libdir=${MY_LIBDIR}"
	myconf+=" --bashcompletiondir=$(get_bashcompdir)"

	if use systemd; then
		myconf+=" --systemdsystemunitdir='$(systemd_get_unitdir)'"
	fi

	econf ${myconf}
}

src_compile() {
	tc-export CC
	emake doc install/dracut-install skipcpio/skipcpio
}

src_install() {
	default

	local my_libdir="${MY_LIBDIR}"
	local dracutlibdir="${my_libdir#/}/dracut"

	echo "DRACUT_VERSION=$PVR" > "${D%/}/${dracutlibdir}/dracut-version.sh"

	insinto "${dracutlibdir}/dracut.conf.d/"
	newins dracut.conf.d/gentoo.conf.example gentoo.conf

	insinto /etc/logrotate.d
	newins dracut.logrotate dracut

	dodir /var/lib/dracut/overlay

	dohtml dracut.html

	if ! use systemd; then
		# Scripts in kernel/install.d are systemd-specific
		rm -r "${D%/}/${my_libdir}/kernel" || die
	fi

	#
	# Modules
	#
	local module
	modules_dir="${D%/}/${dracutlibdir}/modules.d"

	use debug || rm_module 95debug
	use selinux || rm_module 98selinux

	if use systemd; then
		# With systemd following modules do not make sense
		rm_module 96securityfs 97masterkey 98integrity
	else
		rm_module 98systemd
		# Without systemd following modules do not make sense
		rm_module 00systemd-bootchart
	fi

	# Remove modules which won't work for sure
	rm_module 95fcoe # no tools
	# fips module depends on masked app-crypt/hmaccalc
	rm_module 01fips 02fips-aesni
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_src_exists; then
		ewarn ""
		ewarn "If the following test report contains a missing kernel"
		ewarn "configuration option, you should reconfigure and rebuild your"
		ewarn "kernel before booting image generated with this Dracut version."
		ewarn ""

		local CONFIG_CHECK="~BLK_DEV_INITRD ~DEVTMPFS"

		# Kernel configuration options descriptions:
		local desc_DEVTMPFS="Maintain a devtmpfs filesystem to mount at /dev"
		local desc_BLK_DEV_INITRD="Initial RAM filesystem and RAM disk "\
"(initramfs/initrd) support"

		local opt desc

		# Generate ERROR_* variables for check_extra_config.
		for opt in ${CONFIG_CHECK}; do
			opt=${opt#\~}
			desc=desc_${opt}
			eval "local ERROR_${opt}='CONFIG_${opt}: \"${!desc}\"" \
				"is missing and REQUIRED'"
		done

		check_extra_config
		echo
	else
		ewarn ""
		ewarn "Your kernel configuration couldn't be checked.  Do you have"
		ewarn "/usr/src/linux/.config file there?  Please check manually if"
		ewarn "following options are enabled:"
		ewarn ""
		ewarn "  CONFIG_BLK_DEV_INITRD"
		ewarn "  CONFIG_DEVTMPFS"
		ewarn ""
	fi

	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	elog ""
	optfeature "Networking support"  net-misc/curl "net-misc/dhcp[client]" \
		sys-apps/iproute2
	optfeature \
		"Measure performance of the boot process for later visualisation" \
		app-benchmarks/bootchart2 app-admin/killproc sys-process/acct
	optfeature "Scan for Btrfs on block devices"  sys-fs/btrfs-progs
	optfeature "Load kernel modules and drop this privilege for real init" \
		sys-libs/libcap
	optfeature "Support CIFS" net-fs/cifs-utils
	optfeature "Decrypt devices encrypted with cryptsetup/LUKS" \
		"sys-fs/cryptsetup[-static-libs]"
	optfeature "Support for GPG-encrypted keys for crypt module" \
		app-crypt/gnupg
	optfeature \
		"Allows use of dash instead of default bash (on your own risk)" \
		app-shells/dash
	optfeature "Framebuffer splash (media-gfx/splashutils)" \
		media-gfx/splashutils
	optfeature "Support iSCSI" sys-block/open-iscsi
	optfeature "Support Logical Volume Manager" sys-fs/lvm2
	optfeature "Support MD devices, also known as software RAID devices" \
		sys-fs/mdadm
	optfeature "Support Device Mapper multipathing" sys-fs/multipath-tools
	optfeature "Plymouth boot splash"  '>=sys-boot/plymouth-0.8.5-r5'
	optfeature "Support network block devices" sys-block/nbd
	optfeature "Support NFS" net-fs/nfs-utils net-nds/rpcbind
	optfeature \
		"Install ssh and scp along with config files and specified keys" \
		net-misc/openssh
	optfeature "Enable logging with syslog-ng or rsyslog" app-admin/syslog-ng \
		app-admin/rsyslog
}
