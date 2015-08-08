# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils linux-mod linux-info toolchain-funcs flag-o-matic autotools

DESCRIPTION="decode and send infra-red signals of many commonly used remote controls"
HOMEPAGE="http://www.lirc.org/"

MY_P=${PN}-${PV/_/}

if [[ "${PV/_pre/}" = "${PV}" ]]; then
	SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.bz2"
else
	SRC_URI="http://www.lirc.org/software/snapshots/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug doc hardware-carrier transmitter static-libs X"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
	)
	lirc_devices_alsa_usb? ( media-libs/alsa-lib )
	lirc_devices_audio? ( >media-libs/portaudio-18 )
	lirc_devices_irman? ( media-libs/libirman )"

# 2012-07-17, Ian Stakenvicius
# A helper script that scrapes out values for nearly all of the variables below
# from lirc's configure.ac is available at
# http://dev.gentoo.org/~axs/helper-for-lirc-iuse.sh

# This are drivers with names matching the
# parameter --with-driver=NAME
IUSE_LIRC_DEVICES_DIRECT="
	all userspace accent act200l act220l
	adaptec alsa_usb animax asusdh atilibusb
	atiusb audio audio_alsa avermedia avermedia_vdomate
	avermedia98 awlibusb bestbuy bestbuy2 breakoutbox
	bte bw6130 caraca chronos commandir
	cph06x creative creative_infracd
	devinput digimatrix dsp dvico ea65 ene0100
	exaudio flyvideo ftdi gvbctv5pci hauppauge
	hauppauge_dvb hercules_smarttv_stereo i2cuser
	igorplugusb iguanaIR imon imon_24g imon_knob
	imon_lcd imon_pad imon_rsc irdeo irdeo_remote
	irlink irman irreal it87 ite8709
	knc_one kworld leadtek_0007 leadtek_0010
	leadtek_pvr2000 livedrive_midi
	livedrive_seq logitech macmini
	mediafocusI mouseremote
	mouseremote_ps2 mp3anywhere mplay nslu2
	packard_bell parallel pcmak pcmak_usb
	pctv pixelview_bt878 pixelview_pak
	pixelview_pro provideo realmagic
	remotemaster sa1100 samsung sasem sb0540 serial
	silitek sir slinke streamzap tekram
	tekram_bt829 tira ttusbir tuxbox tvbox udp uirt2
	uirt2_raw usb_uirt_raw usbx wpc8769l zotac"

# drivers that need special handling and
# must have another name specified for
# parameter --with-driver=NAME
IUSE_LIRC_DEVICES_SPECIAL="
	serial_igor_cesko
	remote_wonder_plus xboxusb usbirboy inputlirc"

IUSE_LIRC_DEVICES="${IUSE_LIRC_DEVICES_DIRECT} ${IUSE_LIRC_DEVICES_SPECIAL}"

# The following are lists which are used to provide ewarns on incompatibilities
# with the kernel:

#drivers that do not build kernel modules
NO_KMOD_BUILT_FOR_DEV="
	accent bte creative creative_infracd devinput dsp ea65 exaudio
	ftdi i2cuser irlink irreal livedrive_midi livedrive_seq logitech
	mediafocusI mouseremote mouseremote_ps2 mp3anywhere mplay mplay2
	pcmak pcmak_usb pctv realmagic remotemaster silitek tira tira_raw
	tuxbox udp uirt2 uirt2_raw usb_uirt_raw usbx"

#drivers that build lirc_dev and so will conflict with kernel lirc_dev
LIRCDEV_BUILT_FOR_DEV="all
	act200l act220l adaptec animax atiusb breakoutbox hauppauge
	hauppauge_dvb hercules_smarttv_stereo igorplugusb imon imon_24g
	imon_knob imon_lcd imon_pad imon_rsc irdeo irdeo_remote knc_one
	leadtek_pvr2000 nslu2 packard_bell parallel pixelview_bt878
	provideo sa1100 sasem serial sir tekram tekram_bt829 ttusbir
	tvbox wpc8769l zotac"

#lirc_gpio drivers, which cannot be supported on kernel >= 2.6.22
LIRC_GPIO_DEV="
	avermedia avermedia98 avermedia_vdomate bestbuy bestbuy2 chronos
	cph03x cph06x flyvideo gvbctv5pci kworld leadtek_0007 leadtek_0010
	pixelview_pak pixelview_pro"

#device-driver which use libusb
LIBUSB_USED_BY_DEV="
	all atilibusb awlibusb sasem igorplugusb imon imon_lcd imon_pad
	imon_rsc streamzap xboxusb irlink commandir"

for dev in ${LIBUSB_USED_BY_DEV}; do
	DEPEND="${DEPEND} lirc_devices_${dev}? ( virtual/libusb:0 )"
done

# adding only compile-time depends
DEPEND="${RDEPEND} ${DEPEND}
	virtual/linux-sources
	lirc_devices_ftdi? ( dev-embedded/libftdi )
	lirc_devices_all? ( dev-embedded/libftdi )"

# adding only run-time depends
RDEPEND="${RDEPEND}
	lirc_devices_usbirboy? ( app-misc/usbirboy )
	lirc_devices_inputlirc? ( app-misc/inputlircd )
	lirc_devices_iguanaIR? ( app-misc/iguanaIR )"

# add all devices to IUSE
# and ensure lirc_devices_all is not set alongside lirc_devices_*
REQUIRED_USE="lirc_devices_all? ("
for dev in ${IUSE_LIRC_DEVICES}; do
	IUSE="${IUSE} lirc_devices_${dev}"
	if [[ "${dev}" != "all" ]]; then
		REQUIRED_USE="${REQUIRED_USE} !lirc_devices_${dev}"
	fi
done
REQUIRED_USE="${REQUIRED_USE} )"

add_device() {
	local dev="${1}"
	local desc="device ${dev}"
	if [[ -n "${2}" ]]; then
		desc="${2}"
	fi

	# Bug #187418
	if kernel_is ge 2 6 22 && [[ " ${LIRC_GPIO_DEV} " == *" ${dev} "* ]]; then
		eerror "${desc} uses lirc_gpio which fails with kernel 2.6.22 or above.  Not building."
		eerror "Use 'devinput' instead, or use 'userspace' along with in-kernel drivers"
		return 0
	fi
	: ${lirc_device_count:=0}
	((lirc_device_count++))

	elog "Compiling support for ${desc}"

	if [[ " ${LIRCDEV_BUILT_FOR_DEV} " == *" ${dev} "* ]] ; then
		if linux_chkconfig_present LIRC ; then
			ewarn "${desc} builds lirc_dev and CONFIG_LIRC is set in the kernel -- this may conflict."
		fi
		if ! linux_chkconfig_present MODULE_UNLOAD ; then
			ewarn "${desc} builds modules and CONFIG_MODULE_UNLOAD is unset in kernel."
			ewarn "You will need MODULE_UNLOAD support in your kernel."
		fi
	fi
	if [[ " ${NO_KMOD_BUILT_FOR_DEV} " == *" ${dev} "* ]] && ! linux_chkconfig_present IR_LIRC_CODEC ; then
		ewarn "${desc} builds no kernel module and CONFIG_IR_LIRC_CODEC is unset in kernel."
	fi

	if [[ ${lirc_device_count} -eq 2 ]] ; then
		ewarn
		ewarn "LIRC_DEVICES has more than one entry."
		ewarn "When selecting multiple devices for lirc to be supported,"
		ewarn "it can not be guaranteed that the drivers play nice together."
		ewarn "If this is not intended, then please adjust LIRC_DEVICES"
		ewarn "and re-emerge."
		ewarn
	fi

	MY_OPTS="${MY_OPTS} --with-driver=${dev}"
}

pkg_pretend() {
	if [[ -n "${LIRC_OPTS}" ]] ; then
		ewarn
		ewarn "LIRC_OPTS is deprecated from lirc-0.8.0-r1 on."
		ewarn
		ewarn "Please use LIRC_DEVICES from now on."
		ewarn "e.g. LIRC_DEVICES=\"serial sir\""
		ewarn
		ewarn "Flags are now set per use-flags."
		ewarn "e.g. transmitter, hardware-carrier"

		local opt
		local unsupported_opts=""

		# test for allowed options for LIRC_OPTS
		for opt in ${LIRC_OPTS}; do
			case ${opt} in
				--with-port=*|--with-irq=*|--with-timer=*|--with-tty=*)
					MY_OPTS="${MY_OPTS} ${opt}"
					;;
				*)
					unsupported_opts="${unsupported_opts} ${opt}"
					;;
			esac
		done
		if [[ -n ${unsupported_opts} ]]; then
			eerror "These options are no longer allowed to be set"
			eerror "with LIRC_OPTS: ${unsupported_opts}"
			die "LIRC_OPTS is no longer supported, use LIRC_DEVICES."
		fi
	fi
}

pkg_setup() {
	linux-mod_pkg_setup

	# set default configure options
	MY_OPTS=""
	LIRC_DRIVER_DEVICE="/dev/lirc0"

	if use lirc_devices_all; then
		# compile in drivers for a lot of devices
		add_device all "a lot of devices"
	else
		# compile in only requested drivers
		local dev
		for dev in ${IUSE_LIRC_DEVICES_DIRECT}; do
			if use lirc_devices_${dev}; then
				add_device ${dev}
			fi
		done

		if use lirc_devices_remote_wonder_plus; then
			add_device atiusb "device Remote Wonder Plus (atiusb-based)"
		fi

		if use lirc_devices_serial_igor_cesko; then
			add_device serial "serial with Igor Cesko design"
			MY_OPTS="${MY_OPTS} --with-igor"
		fi

		if use lirc_devices_imon_pad; then
			ewarn "The imon_pad driver has incorporated the previous pad2keys patch"
			ewarn "and removed the pad2keys_active option for the lirc_imon module"
			ewarn "because it is always active."
			ewarn "If you have an older imon VFD device, you may need to add the module"
			ewarn "option display_type=1 to override autodetection and force VFD mode."
		fi

		if use lirc_devices_xboxusb; then
			add_device atiusb "device xboxusb"
		fi

		if use lirc_devices_usbirboy; then
			add_device userspace "device usbirboy"
			LIRC_DRIVER_DEVICE="/dev/usbirboy"
		fi

		if [[ "${MY_OPTS}" == "" ]]; then
			if [[ "${PROFILE_ARCH}" == "xbox" ]]; then
				# on xbox: use special driver
				add_device atiusb "device xboxusb"
			else
				# no driver requested
				elog
				elog "Compiling only the lirc-applications, but no drivers."
				elog "Enable drivers with LIRC_DEVICES if you need them."
				MY_OPTS="--with-driver=none"
			fi
		fi
	fi

	use hardware-carrier && MY_OPTS="${MY_OPTS} --without-soft-carrier"
	use transmitter && MY_OPTS="${MY_OPTS} --with-transmitter"

	einfo
	einfo "lirc-configure-opts: ${MY_OPTS}"
	elog  "Setting default lirc-device to ${LIRC_DRIVER_DEVICE}"

	filter-flags -Wl,-O1
}

src_prepare() {
	# Rip out dos CRLF
	edos2unix contrib/lirc.rules

	# Apply patches needed for some special device-types
	use lirc_devices_audio || epatch "${FILESDIR}"/lirc-0.8.4-portaudio_check.patch
	use lirc_devices_remote_wonder_plus && epatch "${FILESDIR}"/lirc-0.8.3_pre1-remotewonderplus.patch

	# Apply fixes for kernel-2.6.39 and above
	epatch "${FILESDIR}"/${P}-kernel-2.6.39-fixes.patch
	# Slightly massaged upstream patch to fix kfifo issues >=2.6.38
	# for bug 377033
	epatch "${FILESDIR}"/${P}-atiusb_kfifo.patch
	# Apply fixes for kernel-3.3 and above (bug 439538)
	epatch "${FILESDIR}"/${P}-kernel-3.3.0-fixes.patch
	# Apply fix for missing err() in usb.h for kernel 3.5+ (bug 444736)
	epatch "${FILESDIR}"/${P}-kernel-3.5-err-fix.patch
	# Apply fix for missing __devinit __devexit defines in kernel 3.8+ (bug 461532)
	epatch "${FILESDIR}"/${P}-kernel-3.8-fixes.patch
	# Add support for zotac remote, bug 342848
	epatch "${FILESDIR}"/${P}-add-zotac-support.patch
	# Use fixed font
	epatch "${FILESDIR}"/${P}-fixed-font.patch

	# Do not build drivers from the top-level Makefile
	sed -i -e 's:\(SUBDIRS =\) drivers\(.*\):\1\2:' Makefile.am

	# remove parallel driver on SMP systems
	if linux_chkconfig_present SMP ; then
		sed -i -e "s:lirc_parallel\.o::" drivers/lirc_parallel/Makefile.am
	fi

	# Bug #187418 - only need this part for lirc_devices_all as others die in pkg_setup
	if use lirc_devices_all && kernel_is ge 2 6 22 ; then
		ewarn "Disabling lirc_gpio driver as it does no longer work Kernel 2.6.22+"
		sed -i -e "s:lirc_gpio\.o::" drivers/lirc_gpio/Makefile.am
	fi

	# respect CFLAGS
	sed -i -e 's:CFLAGS="-O2:CFLAGS=""\n#CFLAGS="-O2:' configure.ac

	# setting default device-node
	local f
	for f in configure.ac acconfig.h; do
		[[ -f "$f" ]] && sed -i -e '/#define LIRC_DRIVER_DEVICE/d' "$f"
	done
	echo "#define LIRC_DRIVER_DEVICE \"${LIRC_DRIVER_DEVICE}\"" >> acconfig.h

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die # automake 1.13
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-syslog=LOG_DAEMON \
		--enable-sandboxed \
		--with-kerneldir="${KV_DIR}" \
		--with-moduledir="/lib/modules/${KV_FULL}/misc" \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with X x) \
		${MY_OPTS} \
		ABI="${KERNEL_ABI}" \
		ARCH="$(tc-arch-kernel)"
}

src_compile() {
	# force non-parallel make, Bug 196134 (confirmed valid for 0.9.0-r2)
	emake -j1

	MODULE_NAMES="lirc(misc:${S}/drivers)"
	BUILD_TARGETS="all"
	linux-mod_src_compile
}

src_install() {
	emake DESTDIR="${D}" install
	emake -C drivers DESTDIR="${D}" install

	newinitd "${FILESDIR}"/lircd-0.8.6-r2 lircd
	newinitd "${FILESDIR}"/lircmd lircmd
	newconfd "${FILESDIR}"/lircd.conf.4 lircd

	insinto /etc/modprobe.d/
	newins "${FILESDIR}"/modprobed.lirc lirc.conf

	newinitd "${FILESDIR}"/irexec-initd-0.8.6-r2 irexec
	newconfd "${FILESDIR}"/irexec-confd irexec

	if use doc ; then
		dohtml doc/html/*.html
		insinto /usr/share/doc/${PF}/images
		doins doc/images/*
	fi

	insinto /usr/share/lirc/remotes
	doins -r remotes/*

	keepdir /etc/lirc
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		newdoc "${D}"/etc/lirc/lircd.conf lircd.conf.example
	fi

	use static-libs || rm "${D}/usr/$(get_libdir)/liblirc_client.la"
}

pkg_preinst() {
	linux-mod_pkg_preinst

	local dir="${EROOT}/etc/modprobe.d"
	if [[ -a "${dir}"/lirc && ! -a "${dir}"/lirc.conf ]]; then
		elog "Renaming ${dir}/lirc to lirc.conf"
		mv -f "${dir}/lirc" "${dir}/lirc.conf"
	fi

	# copy the first file that can be found
	if [[ -f "${EROOT}"/etc/lirc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lirc/lircd.conf "${T}"/lircd.conf
	elif [[ -f "${EROOT}"/etc/lircd.conf ]]; then
		cp "${EROOT}"/etc/lircd.conf "${T}"/lircd.conf
		MOVE_OLD_LIRCD_CONF=1
	elif [[ -f "${D}"/etc/lirc/lircd.conf ]]; then
		cp "${D}"/etc/lirc/lircd.conf "${T}"/lircd.conf
	fi

	# stop portage from touching the config file
	if [[ -e "${D}"/etc/lirc/lircd.conf ]]; then
		rm -f "${D}"/etc/lirc/lircd.conf
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# copy config file to new location
	# without portage knowing about it
	# so it will not delete it on unmerge or ever touch it again
	if [[ -e "${T}"/lircd.conf ]]; then
		cp "${T}"/lircd.conf "${EROOT}"/etc/lirc/lircd.conf
		if [[ "$MOVE_OLD_LIRCD_CONF" = "1" ]]; then
			elog "Moved /etc/lircd.conf to /etc/lirc/lircd.conf"
			rm -f "${EROOT}"/etc/lircd.conf
		fi
	fi

	einfo "The new default location for lircd.conf is inside of"
	einfo "/etc/lirc/ directory"
}
