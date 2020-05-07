# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 python3_7 )

inherit readme.gentoo-r1 autotools perl-functions python-single-r1 toolchain-funcs udev user

DESCRIPTION="Driver library for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="mirror://sourceforge/linux-gpib/${P}.tar.gz
	firmware? ( https://linux-gpib.sourceforge.io/firmware/gpib_firmware-2006-11-12.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="pcmcia static guile perl php python tcl doc firmware"

S="${WORKDIR}/${PN}-user-${PV}"

COMMONDEPEND="
	sys-libs/readline:=
	tcl? ( dev-lang/tcl:0= )
	guile? ( dev-scheme/guile:12 )
	perl? ( dev-lang/perl:= )
	php? ( dev-lang/php:= )
	python? ( ${PYTHON_DEPS} )
	firmware? ( sys-apps/fxload )"
RDEPEND="${COMMONDEPEND}
	~sci-libs/linux-gpib-modules-${PV}
"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	doc? ( app-text/docbook-sgml-utils )
	perl? ( virtual/perl-ExtUtils-MakeMaker )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.16-perl.patch
)

pkg_setup() {
	use perl && perl_set_version
	use python && python_setup
}

src_unpack() {
	default
	unpack "${WORKDIR}/${P}/${PN}-user-${PV}.tar.gz"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static) \
		$(use_enable guile guile-binding) \
		$(use_enable perl perl-binding) \
		$(use_enable php php-binding) \
		$(use_enable python python-binding) \
		$(use_enable tcl tcl-binding) \
		$(use_enable doc documentation)
}

src_compile() {
	FIRM_DIR=/usr/share/usb
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		HOTPLUG_USB_CONF_DIR=/etc/hotplug/usb \
		UDEV_RULES_DIR="$(get_udevdir)"/rules.d \
		USB_FIRMWARE_DIR=${FIRM_DIR} \
		docdir=/usr/share/doc/${PF}/html
}

src_install() {
	FIRM_DIR=/usr/share/usb
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		HOTPLUG_USB_CONF_DIR=/etc/hotplug/usb \
		UDEV_RULES_DIR="$(get_udevdir)"/rules.d \
		USB_FIRMWARE_DIR=${FIRM_DIR} \
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

pkg_preinst() {
	use perl && perl_set_version
	enewgroup gpib
}

pkg_postinst() {
	readme.gentoo_print_elog
}
