# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lcdproc/lcdproc-0.5.6-r1.ebuild,v 1.1 2013/04/18 21:10:22 xmw Exp $

EAPI=5
inherit multilib versionator

MY_PV=$(replace_version_separator 3 '-')
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Client/Server suite to drive all kinds of LCD (-like) devices"
HOMEPAGE="http://lcdproc.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="debug doc ftdi hid irman joystick lirc nfs png samba seamless-hbars truetype usb"

# The following array holds the USE_EXPANDed keywords
IUSE_LCD_DEVICES=(ncurses bayrad cfontz cfontzpacket
	cwlinux eyeboxone g15 graphlcd glk
	hd44780 icpa106 imon imonlcd iowarrior
	lb216 lcdm001 lcterm
	md8800 mdm166a ms6931 mtcs16209x mtxorb noritakevfd
	pyramid sdeclcd sed1330 sed1520 serialvfd sli
	stv5730 SureElec svga t6963 text tyan
	ula200 vlsys_m428 xosd ea65 picolcd serialpos
	i2500vfd irtrans lis shuttlevfd )

# Iterate through the array and add the lcd_devices_* that we support
NUM_DEVICES=${#IUSE_LCD_DEVICES[@]}
index=0
while [ "${index}" -lt "${NUM_DEVICES}" ] ; do
	IUSE="${IUSE} lcd_devices_${IUSE_LCD_DEVICES[${index}]}"
	let "index = ${index} + 1"
done

REQUIRED_USE="lcd_devices_mdm166a? ( hid )"

RDEPEND="
	ftdi?     ( dev-embedded/libftdi )
	hid?	  ( >=dev-libs/libhid-0.2.16 )
	irman?    ( media-libs/libirman )
	lirc?     ( app-misc/lirc )
	png?      ( media-libs/libpng:0 )
	truetype? ( media-libs/freetype:2 )
	usb?      ( virtual/libusb:0 )

	lcd_devices_graphlcd?  ( app-misc/graphlcd-base  app-misc/glcdprocdriver dev-libs/serdisplib )
	lcd_devices_g15?       ( dev-libs/libg15  dev-libs/libg15render )
	lcd_devices_ncurses?   ( sys-libs/ncurses )
	lcd_devices_svga?      ( media-libs/svgalib )
	lcd_devices_ula200?    ( dev-embedded/libftdi )
	lcd_devices_xosd?      ( x11-libs/xosd  x11-libs/libX11  x11-libs/libXext )
	lcd_devices_cfontzpacket? ( virtual/libusb:0 )
	lcd_devices_cwlinux?    ( virtual/libusb:0 )
	lcd_devices_pyramid?    ( virtual/libusb:0 )
	lcd_devices_picolcd?    ( virtual/libusb:0 )
	lcd_devices_i2500vfd?   ( dev-embedded/libftdi )
	lcd_devices_lis?        ( dev-embedded/libftdi virtual/libusb:0 )
	lcd_devices_shuttlevfd? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto
	       app-text/docbook-xml-dtd:4.5 )"
RDEPEND="${RDEPEND}
	lcd_devices_g15?      ( app-misc/g15daemon )"

pkg_setup() {
	if [ -n "${LCDPROC_DRIVERS}" ] ; then
		ewarn "Setting the drivers to compile via LCDPROC_DRIVERS is not supported anymore."
		ewarn "Please use LCD_DEVICES now and see emerge -pv output for the options."
	fi
}

src_prepare() {
	sed -i "37s:server/drivers:/usr/$(get_libdir)/lcdproc:" LCDd.conf || die
	einfo "Patching LCDd.conf to use DriverPath=/usr/$(get_libdir)/lcdproc/"
}

src_configure() {
	# This array contains the driver names required by configure --with-drivers=
	# The positions must be the same as the corresponding use_expand flags
	local DEVICE_DRIVERS=(curses bayrad CFontz CFontzPacket
		CwLnx EyeboxOne g15 glcd,glcdlib glk
		hd44780 icp_a106 imon imonlcd IOWarrior
		lb216 lcdm001 lcterm
		MD8800 mdm166a ms6931 mtc_s16209x MtxOrb NoritakeVFD
		pyramid sdeclcd sed1330 sed1520 serialVFD sli
		stv5730 SureElec svga t6963 text tyan
		ula200 vlsys_m428 xosd ea65 picolcd serialPOS
		i2500vfd irtrans lis shuttleVFD )

	# Generate comma separated list of drivers
	COMMA_DRIVERS=""
	FIRST_DRIVER=""
	local index=0

	while [ "${index}" -lt "${NUM_DEVICES}" ] ; do
		if use "lcd_devices_${IUSE_LCD_DEVICES[${index}]}" ; then
			append-driver "${DEVICE_DRIVERS[${index}]}"
		fi
		let "index = ${index} + 1"
	done

	# Append the not-lcd-drivers (input)
	use lirc && append-driver "lirc"
	use irman && append-driver "irman"
	use joystick && append-driver "joy"

	if [ -z "${COMMA_DRIVERS}" ] ; then
		ewarn "You are compiling LCDd without support for any LCD drivers at all."
	else
		# Patch the config to contain a driver that is actually installed instead of the default
		elog "Compiling the following drivers for LCDd: ${COMMA_DRIVERS}"
		elog "Setting Driver=${FIRST_DRIVER} in LCDd.conf"
		sed -i "53s:curses:${FIRST_DRIVER}:" LCDd.conf || die
	fi

	local EXTRA_CONF
	if use lcd_devices_cfontzpacket || use lcd_devices_cwlinux || use lcd_devices_pyramid || \
		use lcd_devices_picolcd || use lcd_devices_lis || use lcd_devices_shuttlevfd ; then
		EXTRA_CONF="--enable-libusb"
	else
		EXTRA_CONF="$(use_enable usb libusb)"
	fi

	if use lcd_devices_ula200 || use lcd_devices_i2500vfd || use lcd_devices_lis ; then
		EXTRA_CONF="${EXTRA_CONF} --enable-libftdi"
	else
		EXTRA_CONF="${EXTRA_CONF} $(use_enable ftdi libftdi)"
	fi

	econf --enable-extra-charmaps \
		$(use_enable debug) \
		$(use_enable nfs stat-nfs) \
		$(use_enable png libpng) \
		$(use_enable samba stat-smbfs ) \
		$(use_enable seamless-hbars) \
		$(use_enable truetype freetype) \
		${EXTRA_CONF} \
		"--enable-drivers=${COMMA_DRIVERS}"
}

src_compile() {
	default

	if use doc; then
		ebegin "Creating user documentation"
		cd "${S}"/docs/lcdproc-user
		xmlto html --skip-validation lcdproc-user.docbook
		eend $?

		ebegin "Creating dev documentation"
		cd "${S}"/docs/lcdproc-dev
		xmlto html --skip-validation lcdproc-dev.docbook
		eend $?
	fi
}

append-driver() {
	[[ -z $* ]] && return 0
	if [ -z "${COMMA_DRIVERS}" ] ; then
		# First in the list
		COMMA_DRIVERS="$*"
		FIRST_DRIVER="$*"
	else
		# Second, third, ... include a comma at the front
		COMMA_DRIVERS="${COMMA_DRIVERS},$*"
	fi
	return 0
}

src_install() {
	emake DESTDIR="${D}" install

	# move example clients installed to /usr/bin
	rm -f "${D}"/usr/bin/{tail,lcdmetar,iosock,fortune,x11amp}.pl
	insinto /usr/share/lcdproc/clients
	doins clients/examples/*.pl
	doins clients/metar/*.pl

	newinitd "${FILESDIR}/0.5.1-LCDd.initd" LCDd
	newinitd "${FILESDIR}/0.5.2-r2-lcdproc.initd" lcdproc

	dodoc README CREDITS ChangeLog INSTALL TODO

	if use doc; then
		insinto /usr/share/doc/${PF}/lcdproc-user
		doins docs/lcdproc-user/*.html
		insinto /usr/share/doc/${PF}/lcdproc-dev
		doins docs/lcdproc-dev/*.html
	fi
}
