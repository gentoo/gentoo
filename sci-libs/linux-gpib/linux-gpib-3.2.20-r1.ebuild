# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/linux-gpib/linux-gpib-3.2.20-r1.ebuild,v 1.11 2015/04/08 18:49:16 mgorny Exp $

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python2_7 )

inherit eutils linux-mod autotools perl-module python-single-r1 toolchain-funcs udev user

DESCRIPTION="Kernel module and driver library for GPIB (IEEE 488.2) hardware"
HOMEPAGE="http://linux-gpib.sourceforge.net/"
SRC_URI="mirror://sourceforge/linux-gpib/${P}.tar.gz
	firmware? ( http://linux-gpib.sourceforge.net/firmware/gpib_firmware-2006-11-12.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="isa pcmcia static debug guile perl php python tcl doc firmware"

COMMONDEPEND="
	tcl? ( dev-lang/tcl:0= )
	guile? ( dev-scheme/guile:12 )
	perl? ( dev-lang/perl:= )
	php? ( dev-lang/php:= )
	python? ( ${PYTHON_DEPS} )
	firmware? ( sys-apps/fxload )"
RDEPEND="${COMMONDEPEND}"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	perl? ( virtual/perl-ExtUtils-MakeMaker )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.15-build.patch
	"${FILESDIR}"/${PN}-3.2.16-perl.patch
	"${FILESDIR}"/${PN}-3.2.16-reallydie.patch
)

pkg_setup () {
	use perl && perl_set_version
	use python && python_setup
	linux-mod_pkg_setup

	if kernel_is -lt 2 6 8; then
		die "Kernel versions older than 2.6.8 are not supported."
	fi

	# https://sourceforge.net/tracker/?func=detail&aid=3285657&group_id=42378&atid=432940
	if use pcmcia && kernel_is -ge 2 6 38; then
		die "pcmcia support is broken on kernels newer 2.6.38"
	fi
}

src_prepare () {
	epatch ${PATCHES[@]}
	epatch_user
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		$(use_enable isa) \
		$(use_enable pcmcia) \
		$(use_enable static) \
		$(use_enable debug driver-debug) \
		$(use_enable guile guile-binding) \
		$(use_enable perl perl-binding) \
		$(use_enable php php-binding) \
		$(use_enable python python-binding) \
		$(use_enable tcl tcl-binding) \
		$(use_enable doc documentation) \
		--with-linux-srcdir=${KV_DIR}
}

src_compile() {
	set_arch_to_kernel
	FIRM_DIR=/usr/share/usb
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		HOTPLUG_USB_CONF_DIR="${D}"/etc/hotplug/usb \
		USB_FIRMWARE_DIR="${D}"${FIRM_DIR} \
		docdir=/usr/share/doc/${PF}/html
}

src_install() {
	set_arch_to_kernel
	FIRM_DIR=/usr/share/usb
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		HOTPLUG_USB_CONF_DIR="${D}"/etc/hotplug/usb \
		USB_FIRMWARE_DIR="${D}"${FIRM_DIR} \
		docdir=/usr/share/doc/${PF}/html install

	if use perl; then
		einfo "Installing perl module"
		cd "${S}"/language/perl || die
		DESTDIR=${D} perl-module_src_install
		cd "${S}" || die
	fi

	echo "KERNEL==\"gpib[0-9]*\",	MODE=\"0660\", GROUP=\"gpib\"" >> 99-gpib.rules
	udev_dorules 99-gpib.rules

	dodoc doc/linux-gpib.pdf ChangeLog AUTHORS README* NEWS

	insinto /etc
	newins util/templates/gpib.conf gpib.conf
	newins util/templates/gpib.conf gpib.conf.example

	if use pcmcia; then
		dodir /etc/pcmcia
		insinto /etc/pcmcia
		doins "${S}"/etc/pcmcia/*
	fi

	if use firmware; then
		insinto "${FIRM_DIR}"/agilent_82357a
		doins "${WORKDIR}"/gpib_firmware-2006-11-12/agilent_82357a/*

		insinto "${FIRM_DIR}"/ni_gpib_usb_b
		doins "${WORKDIR}"/gpib_firmware-2006-11-12/ni_gpib_usb_b/*

		insinto /usr/share/linux-gpib/hp_82341
		# do not install precompiled generate_firmware
		doins "${WORKDIR}"/gpib_firmware-2006-11-12/hp_82341/{*.bin,README}
	fi
}

pkg_preinst () {
	linux-mod_pkg_preinst
	use perl && perl_set_version
	enewgroup gpib
}

pkg_postinst () {
	linux-mod_pkg_postinst

	einfo "You need to run the 'gpib_config' utility to setup the driver before"
	einfo "you can use it. In order to do it automatically you can add to your"
	einfo "start script something like this (supposing the appropriate driver"
	einfo "is loaded on the startup):"
	einfo "		gpib_config --minor 0"
	einfo ""
	einfo "To give a user access to the computer's gpib board you will have to add"
	einfo "them to the group 'gpib' or, you could change the permissions on the device"
	einfo "files /dev/gpib[0-15] to something you like better, using 'chmod'."
	einfo ""
	einfo "Edit /etc/gpib.conf to match your interface board, and any devices you wish"
	einfo "to open via ibfind().  See the documentation in /usr/share/linux-gpib/html for"
	einfo "more information."
	einfo ""

	if use pcmcia; then
		einfo "For PCMCIA cards:"
		einfo "All files needed for a PCMCIA board were copied to /etc/pcmcia."
		einfo "You may wish to edit the options passed to the gpib_config call in the"
		einfo "/etc/pcmcia/linux-gpib-pcmcia script."
		einfo "You may need to send a SIGHUP signal to the cardmgr daemon to force it"
		einfo "to reload the files in /etc/pcmcia (alternatively you could use your"
		einfo "pcmcia init.d script to restart the cardmgr, or you could just reboot)."
		einfo "The driver module will be loaded as needed by the cardmgr."
		einfo ""
	fi

	if use firmware; then
		einfo "For Agilent (HP) 82341C and 82341D cards:"
		einfo "The firmware for these boards is uploaded by passing the appropriate"
		einfo "firmware file from /usr/share/linux-gpib/hp_82341 directory to"
		einfo "gpib_config using the -I or --init-data command line option. Example:"
		einfo "gpib_config --minor 0 --init-data \\"
		einfo "/usr/share/linux-gpib/hp_82341/hp_82341c_fw.bin"
		einfo ""
	fi

}
