# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit linux-info readme.gentoo-r1 versionator eutils linux-mod autotools perl-functions python-single-r1 toolchain-funcs udev user

MY_PV=${PV/_/}

DESCRIPTION="Kernel module and driver library for GPIB (IEEE 488.2) hardware"
HOMEPAGE="http://linux-gpib.sourceforge.net/"
SRC_URI="mirror://sourceforge/linux-gpib/${PN}-${MY_PV}.tar.gz
	firmware? ( http://linux-gpib.sourceforge.net/firmware/gpib_firmware-2006-11-12.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="isa pcmcia static debug guile perl php python tcl doc firmware"

COMMONDEPEND="
	sys-libs/readline:=
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
	"${FILESDIR}"/${PN}-3.2.21-build.patch
	"${FILESDIR}"/${PN}-3.2.16-perl.patch
	"${FILESDIR}"/${PN}-4.0.3-reallydie.patch
)

S=${WORKDIR}/${PN}-${MY_PV}

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
	default
	kernel_is ge 4 11 0 && eapply "${FILESDIR}"/${PN}-4.0.4_rc2-kernel-4.11.0.patch
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
		UDEV_RULES_DIR="${D}$(get_udevdir)"/rules.d \
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
		UDEV_RULES_DIR="${D}/$(get_udevdir)"/rules.d \
		USB_FIRMWARE_DIR="${D}"${FIRM_DIR} \
		docdir=/usr/share/doc/${PF}/html install

	if use perl; then
		einfo "Installing perl module"
		cd "${S}"/language/perl || die
		DESTDIR=${D} emake install
		perl_fix_packlist
		perl_delete_emptybsdir
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

	# fix rules files
	local f
	find "${D}$(get_udevdir)"/rules.d -type f -print0 | while read -rd '' f ; do
		grep -q "${D}" "${f}" && einfo "File ${f} contains a temporary path, fixing."
		sed -i -e "s:${D}:/:g" "${f}"
	done

	DOC_CONTENTS="
You need to run the 'gpib_config' utility to setup the driver before
you can use it. In order to do it automatically you can add to your
start script something like this (supposing the appropriate driver
is loaded on the startup):
\n
		gpib_config --minor 0
\n
To give a user access to the computer's gpib board you will have to add
them to the group 'gpib' or, you could change the permissions on the device
files /dev/gpib[0-15] to something you like better, using 'chmod'
\n
Edit /etc/gpib.conf to match your interface board, and any devices you wish
to open via ibfind().  See the documentation in /usr/share/linux-gpib/html for
more information.
\n
"

	if use pcmcia; then
		DOC_CONTENTS+='
For PCMCIA cards:\n
All files needed for a PCMCIA board were copied to /etc/pcmcia.
You may wish to edit the options passed to the gpib_config call in the
/etc/pcmcia/linux-gpib-pcmcia script.
You may need to send a SIGHUP signal to the cardmgr daemon to force it
to reload the files in /etc/pcmcia \(alternatively you could use your
pcmcia init.d script to restart the cardmgr, or you could just reboot\).
The driver module will be loaded as needed by the cardmgr.

'
	fi

	if use firmware; then
		DOC_CONTENTS+='
For Agilent \(HP\) 82341C and 82341D cards:
The firmware for these boards is uploaded by passing the appropriate
firmware file from /usr/share/linux-gpib/hp_82341 directory to
gpib_config using the -I or --init-data command line option. Example:\n
gpib_config --minor 0 --init-data /usr/share/linux-gpib/hp_82341/hp_82341c_fw.bin
'
	fi

	readme.gentoo_create_doc
}

pkg_preinst () {
	linux-mod_pkg_preinst
	use perl && perl_set_version
	enewgroup gpib
}

pkg_postinst () {
	linux-mod_pkg_postinst
	readme.gentoo_print_elog

	local v
		for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 3.2.21-r1 ${v}; then
			ewarn "sci-libs/linux-gpib-3.2.21-r1 introduces incompatible changes to the kernel"
			ewarn "interface. You may need to reboot to make sure the newly built driver modules"
			ewarn "are used (some of the driver modules cannot be unloaded)."
			ewarn "If you do not do this, every gpib call will just result in an error message."
			break
		fi
	done
}
