# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lcdproc/lcdproc-0.5.2-r1.ebuild,v 1.11 2012/07/29 16:19:03 armin76 Exp $

WANT_AUTOMAKE="1.9"
inherit eutils autotools multilib

DESCRIPTION="Client/Server suite to drive all kinds of LCD (-like) devices"
HOMEPAGE="http://lcdproc.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-patches.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

IUSE="doc debug nfs samba seamless-hbars usb lirc irman joystick"

# The following array holds the USE_EXPANDed keywords
IUSE_LCD_DEVICES=(ncurses bayrad cfontz cfontz633 cfontzpacket
	cwlinux eyeboxone g15 graphlcd glk
	hd44780 icpa106 imon iowarrior
	lb216 lcdm001 lcterm
	md8800 ms6931 mtcs16209x mtxorb noritakevfd
	pyramid sed1330 sed1520 serialvfd sli
	stv5730 svga t6963 text tyan
	ula200 xosd ea65 picolcd serialpos )

# Iterate through the array and add the lcd_devices_* that we support
NUM_DEVICES=${#IUSE_LCD_DEVICES[@]}
index=0
while [ "${index}" -lt "${NUM_DEVICES}" ] ; do
	IUSE="${IUSE} lcd_devices_${IUSE_LCD_DEVICES[${index}]}"
	let "index = ${index} + 1"
done

RDEPEND="
	usb?      ( =virtual/libusb-0* )
	lirc?     ( app-misc/lirc )
	irman?    ( media-libs/libirman )

	lcd_devices_graphlcd?  ( app-misc/graphlcd-base  app-misc/glcdprocdriver )
	lcd_devices_g15?      ( dev-libs/libg15  >=dev-libs/libg15render-1.1.1 )
	lcd_devices_ncurses?   ( sys-libs/ncurses )
	lcd_devices_svga?     ( media-libs/svgalib )
	lcd_devices_ula200?   ( >=dev-embedded/libftdi-0.7  =virtual/libusb-0* )
	lcd_devices_xosd?     ( x11-libs/xosd  x11-libs/libX11  x11-libs/libXext )
	lcd_devices_cfontzpacket? ( =virtual/libusb-0* )
	lcd_devices_cwlinux?    ( =virtual/libusb-0* )
	lcd_devices_pyramid?  ( =virtual/libusb-0* )
	lcd_devices_picolcd?  ( =virtual/libusb-0* )"
DEPEND="${RDEPEND}
	doc?      ( app-text/xmlto )"
RDEPEND="${RDEPEND}
	lcd_devices_g15?      ( app-misc/g15daemon )"

pkg_setup() {
	if [ -n "${LCDPROC_DRIVERS}" ] ; then
		ewarn "Setting the drivers to compile via LCDPROC_DRIVERS is not supported anymore."
		ewarn "Please use LCD_DEVICES now and see emerge -pv output for the options."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}/${P}-patches/${PV}-picolcd.patch"

	sed -i "79s:server/drivers:/usr/$(get_libdir)/lcdproc:" LCDd.conf
	einfo "Patching LCDd.conf to use DriverPath=/usr/$(get_libdir)/lcdproc/"

	eautoreconf
}

src_compile() {
	# This array contains the driver names required by configure --with-drivers=
	# The positions must be the same as the corresponding use_expand flags
	local DEVICE_DRIVERS=(curses bayrad CFontz CFontz633 CFontzPacket
		CwLnx EyeboxOne g15 glcdlib glk
		hd44780 icp_a106 imon IOWarrior
		lb216 lcdm001 lcterm
		MD8800 ms6931 mtc_s16209x MtxOrb NoritakeVFD
		pyramid sed1330 sed1520 serialVFD sli
		stv5730 svga t6963 text tyan
		ula200 xosd ea65 picolcd serialPOS)

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
		sed -i "44s:curses:${FIRST_DRIVER}:" LCDd.conf
	fi

	local ENABLEUSB
	if use lcd_devices_cfontzpacket || use lcd_devices_cwlinux || use lcd_devices_pyramid; then
		ENABLEUSB="--enable-libusb"
	else
		ENABLEUSB="$(use_enable usb libusb)"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable nfs stat-nfs) \
		$(use_enable samba stat-smbfs ) \
		$(use_enable seamless-hbars) \
		${ENABLEUSB} \
		"--enable-drivers=${COMMA_DRIVERS}"  \
		|| die "configure failed"

	emake || die "make failed"

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
	emake DESTDIR="${D}" install || die "make install failed"

	# move example clients installed to /usr/bin
	rm -f "${D}"/usr/bin/{tail,lcdmetar,iosock,fortune,x11amp}.pl
	insinto /usr/share/lcdproc/clients
	doins clients/examples/*.pl
	doins clients/metar/

	newinitd "${FILESDIR}/0.5.1-LCDd.initd" LCDd
	newinitd "${FILESDIR}/0.5.1-lcdproc.initd" lcdproc

	dodoc README CREDITS ChangeLog INSTALL TODO
	dodoc docs/README.* docs/*.txt

	if use doc; then
		insinto /usr/share/doc/${PF}/lcdproc-user
		doins docs/lcdproc-user/*.html
		insinto /usr/share/doc/${PF}/lcdproc-dev
		doins docs/lcdproc-dev/*.html
	fi
}

pkg_postinst() {
	ewarn "IMPORTANT: Please update your /etc/LCDd.conf"
	ewarn "As of lcdproc-0.5.1-r2, the DriverPath changed from /usr/share/lcdproc to /usr/$(get_libdir)/lcdproc ."
}
