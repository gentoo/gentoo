# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit bash-completion-r1 eutils linux-info multilib systemd

add_req_use_for() {
	local dep="$1"; shift
	local f

	for f in "$@"; do
		REQUIRED_USE+="${f}? ( ${dep} )
"
	done
}

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="https://dracut.wiki.kernel.org"
AIDECOE_DISTFILES="https://dev.gentoo.org/~aidecoe/distfiles"
SRC_URI="mirror://kernel/linux/utils/boot/${PN}/${P}.tar.bz2
	${AIDECOE_DISTFILES}/${CATEGORY}/${PN}/${PV}-0010-module-setup.sh-add-comments.patch.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

REQUIRED_USE="
	dracut_modules_bootchart? ( !dracut_modules_systemd )
	dracut_modules_crypt-gpg? ( dracut_modules_crypt )
	dracut_modules_crypt-loop? ( dracut_modules_crypt )
	dracut_modules_livenet? ( dracut_modules_dmsquash-live )
	"
COMMON_MODULES="
	dracut_modules_biosdevname
	dracut_modules_bootchart
	dracut_modules_btrfs
	dracut_modules_caps
	dracut_modules_crypt-gpg
	dracut_modules_crypt-loop
	dracut_modules_dash
	dracut_modules_gensplash
	dracut_modules_mdraid
	dracut_modules_multipath
	dracut_modules_plymouth
	dracut_modules_syslog
	dracut_modules_systemd
	"
DM_MODULES="
	dracut_modules_crypt
	dracut_modules_dmraid
	dracut_modules_dmsquash-live
	dracut_modules_livenet
	dracut_modules_lvm
	"
NETWORK_MODULES="
	dracut_modules_cifs
	dracut_modules_iscsi
	dracut_modules_livenet
	dracut_modules_nbd
	dracut_modules_nfs
	dracut_modules_ssh-client
	"
add_req_use_for device-mapper ${DM_MODULES}
add_req_use_for net ${NETWORK_MODULES}
IUSE_DRACUT_MODULES="${COMMON_MODULES} ${DM_MODULES} ${NETWORK_MODULES}"
IUSE="debug device-mapper net selinux ${IUSE_DRACUT_MODULES}"

RESTRICT="test"

CDEPEND="virtual/udev
	!>=sys-fs/udev-210
	!>=sys-apps/systemd-210
	dracut_modules_systemd? ( >=sys-apps/systemd-199 )
	selinux? ( sec-policy/selinux-dracut )
	"
RDEPEND="${CDEPEND}
	app-arch/cpio
	>=app-shells/bash-4.0
	>=sys-apps/baselayout-1.12.14-r1
	>sys-apps/kmod-5[tools]
	|| ( >=sys-apps/sysvinit-2.87-r3 sys-apps/systemd[sysv-utils] sys-apps/systemd-sysv-utils )
	>=sys-apps/util-linux-2.21

	debug? ( dev-util/strace )
	device-mapper? ( >=sys-fs/lvm2-2.02.33 )
	net? ( net-misc/curl >=net-misc/dhcp-4.2.4_p2-r1[client] sys-apps/iproute2 )
	selinux? ( sys-libs/libselinux sys-libs/libsepol )
	dracut_modules_biosdevname? ( sys-apps/biosdevname )
	dracut_modules_bootchart? ( app-admin/killproc app-benchmarks/bootchart2
		sys-process/acct )
	dracut_modules_btrfs? ( sys-fs/btrfs-progs )
	dracut_modules_caps? ( sys-libs/libcap )
	dracut_modules_cifs? ( net-fs/cifs-utils )
	dracut_modules_crypt? ( sys-fs/cryptsetup )
	dracut_modules_crypt-gpg? ( app-crypt/gnupg )
	dracut_modules_dash? ( >=app-shells/dash-0.5.4.11 )
	dracut_modules_dmraid? ( sys-fs/dmraid sys-fs/multipath-tools )
	dracut_modules_gensplash? ( media-gfx/splashutils )
	dracut_modules_iscsi? ( >=sys-block/open-iscsi-2.0.871.3 )
	dracut_modules_lvm? ( >=sys-fs/lvm2-2.02.33 )
	dracut_modules_mdraid? ( >=sys-fs/mdadm-3.2.6-r1 )
	dracut_modules_multipath? ( sys-fs/multipath-tools )
	dracut_modules_nbd? ( sys-block/nbd )
	dracut_modules_nfs? ( net-fs/nfs-utils net-nds/rpcbind )
	dracut_modules_plymouth? ( >=sys-boot/plymouth-0.8.3-r1 )
	dracut_modules_ssh-client? ( net-misc/openssh )
	dracut_modules_syslog? ( || ( app-admin/syslog-ng app-admin/rsyslog ) )
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

#
# Helper functions
#

# Returns true if any of specified modules is enabled by USE flag and false
# otherwise.
# $1 = list of modules (which have corresponding USE flags of the same name)
any_module() {
	local m modules=" $@ "

	for m in ${modules}; do
		! use $m && modules=${modules/ $m / }
	done

	shopt -s extglob
	modules=${modules%%+( )}
	shopt -u extglob

	[[ ${modules} ]]
}

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

#
# ebuild functions
#

src_prepare() {
	epatch "${FILESDIR}/${PV}-0001-dracut.sh-do-not-bail-out-if-kernel-mo.patch"
	epatch "${FILESDIR}/${PV}-0002-dracut-functions.sh-support-for-altern.patch"
	epatch "${FILESDIR}/${PV}-0003-gentoo.conf-let-udevdir-be-handled-by-.patch"
	epatch "${FILESDIR}/${PV}-0004-Use-the-same-paths-in-dracut.sh-as-tho.patch"
	epatch "${FILESDIR}/${PV}-0005-Install-dracut-install-into-libexec-di.patch"
	epatch "${FILESDIR}/${PV}-0006-resume-fix-swap-detection-in-hostonly.patch"
	epatch "${FILESDIR}/${PV}-0007-dracut.sh-also-mkdir-run-lock-which-is.patch"
	epatch "${FILESDIR}/${PV}-0008-dracut.sh-no-need-to-make-subdirs-in-r.patch"
	epatch "${FILESDIR}/${PV}-0009-lvm-install-thin-utils-for-non-hostonl.patch"
	epatch "${DISTDIR}/${PV}-0010-module-setup.sh-add-comments.patch.bz2"
	epatch "${FILESDIR}/${PV}-0011-lvm-fix-thin-recognition.patch"
	epatch "${FILESDIR}/${PV}-0012-lvm-always-install-thin-utils-for-lvm.patch"
	epatch "${FILESDIR}/${PV}-0013-usrmount-always-install.patch"
	epatch "${FILESDIR}/${PV}-0014-udev-rules-add-eudev-rules.patch"

	local libdirs="/$(get_libdir) /usr/$(get_libdir)"
	[[ $libdirs =~ /lib\  ]] || libdirs+=" /lib /usr/lib"
	einfo "Setting libdirs to \"${libdirs}\" ..."
	sed -e "3alibdirs=\"${libdirs}\"" \
		-i "${S}/dracut.conf.d/gentoo.conf.example" || die

	local udevdir="$("$(tc-getPKG_CONFIG)" udev --variable=udevdir)"
	einfo "Setting udevdir to ${udevdir}..."
	sed -r -e "s|^(udevdir=).*$|\1${udevdir}|" \
			-i "${S}/dracut.conf.d/gentoo.conf.example" || die

	if use dracut_modules_systemd; then
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
	fi

	epatch_user
}

src_configure() {
	local myconf="--libdir=${MY_LIBDIR}"
	myconf+=" --bashcompletiondir=$(get_bashcompdir)"

	if use dracut_modules_systemd; then
		myconf+=" --systemdsystemunitdir='$(systemd_get_unitdir)'"
	fi

	econf ${myconf}
}

src_compile() {
	tc-export CC
	emake doc install/dracut-install
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

	#
	# Modules
	#
	local module
	modules_dir="${D%/}/${dracutlibdir}/modules.d"

	# Remove modules not enabled by USE flags
	for module in ${IUSE_DRACUT_MODULES} ; do
		! use ${module} && rm_module -f ${module#dracut_modules_}
	done

	# Those flags are specific, and even are corresponding to modules, they need
	# to be declared as regular USE flags.
	use debug || rm_module 95debug
	use selinux || rm_module 98selinux

	# Following flags define set of helper modules which are base dependencies
	# for others and as so have no practical use, so remove these modules.
	use device-mapper  || rm_module 90dm
	use net || rm_module 40network 45ifcfg 45url-lib

	if use dracut_modules_systemd; then
		# With systemd following modules do not make sense
		rm_module 96securityfs 98selinux
	else
		# Without systemd following modules do not make sense
		rm_module 00systemd-bootchart
	fi

	# Remove S/390 modules which are not tested at all
	rm_module 80cms 95dasd 95dasd_mod 95zfcp 95znet

	# Remove modules which won't work for sure
	rm_module 95fcoe # no tools
	# fips module depends on masked app-crypt/hmaccalc
	rm_module 01fips 02fips-aesni

	# Remove extra modules which go to future dracut-extras
	rm_module 05busybox 97masterkey 98ecryptfs 98integrity
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_exists; then
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

	if use dracut_modules_crypt || use dracut_modules_dmraid || use \
		dracut_modules_mdraid || use dracut_modules_lvm; then

		if ! [[ $(</proc/cmdline) =~ rd.auto[\ =] ]]; then
			ewarn "Autoassembly of special devices like cryptoLUKS, dmraid, "
			ewarn "mdraid or lvm is off for default as of  >=dracut-024."
			ewarn "Use rd.auto option to turn it on."
		fi
	fi
}
