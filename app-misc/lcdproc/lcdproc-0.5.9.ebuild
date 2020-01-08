# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd

DESCRIPTION="Displays real-time system information from your Linux/*BSD box on a LCD"
HOMEPAGE="http://www.lcdproc.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz
	https://raw.githubusercontent.com/lcdproc/lcdproc/master/docs/lcdproc-user/drivers/linux_input.docbook"

KEYWORDS="amd64 ppc ppc64 x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc ethlcd extra-charmaps freetype menu nfs png samba test-menu"
REQUIRED_USE="ethlcd? ( lcd_devices_hd44780 )
	freetype? ( lcd_devices_glcd )
	png? ( lcd_devices_glcd )"

# Define the list of valid lcd devices.
# Some drivers were removed from this list:
# - svga: It needs media-libs/svgalib, which is masked and obsolete.
IUSE_LCD_DEVICES=( bayrad CFontz CFontzPacket curses CwLnx ea65
	EyeboxOne futaba g15 glcd glcdlib glk hd44780 i2500vfd
	icp_a106 imon imonlcd IOWarrior irman irtrans
	joy lb216 lcdm001 lcterm linux_input lirc lis MD8800 mdm166a
	ms6931 mtc_s16209x MtxOrb mx5000 NoritakeVFD
	Olimex_MOD_LCD1x9 picolcd pyramid rawserial
	sdeclcd sed1330 sed1520 serialPOS serialVFD
	shuttleVFD sli stv5730 SureElec t6963 text
	tyan ula200 vlsys_m428 xosd yard2LCD )

# Add supported drivers from 'IUSE_LCD_DEVICES' to 'IUSE' and 'REQUIRED_USE'
REQUIRED_USE+=" || ( "
for LCD_DEVICE in "${IUSE_LCD_DEVICES[@]}"; do
	LCD_DEVICE="${LCD_DEVICE,,}"
	IUSE+=" lcd_devices_${LCD_DEVICE} "
	REQUIRED_USE+=" lcd_devices_${LCD_DEVICE} "
done
REQUIRED_USE+=" ) "
unset LCD_DEVICE

# Define dependencies for all drivers in 'IUSE_LCD_DEVICES'
DEPEND_LCD_DEVICES="lcd_devices_cfontz? ( dev-libs/libhid:= )
	lcd_devices_cfontzpacket? ( dev-libs/libhid:= )
	lcd_devices_cwlnx? ( dev-libs/libhid:= )
	lcd_devices_futaba? ( virtual/libusb:1= )
	lcd_devices_g15? ( app-misc/g15daemon
		dev-libs/libg15render:=
		virtual/libusb:0= )
	lcd_devices_glcd? ( app-misc/glcdprocdriver:=
		dev-embedded/libftdi:1=
		dev-libs/libhid:=
		dev-libs/serdisplib:=
		virtual/libusb:0=
		x11-libs/libX11:= )
	lcd_devices_hd44780? ( dev-embedded/libftdi:1=
		dev-libs/libugpio:=
		virtual/libusb:0= )
	lcd_devices_i2500vfd? ( dev-embedded/libftdi:1= )
	lcd_devices_irman? ( media-libs/libirman:= )
	lcd_devices_iowarrior? ( virtual/libusb:0= )
	lcd_devices_lirc? ( app-misc/lirc )
	lcd_devices_lis? ( dev-embedded/libftdi:1= )
	lcd_devices_lb216? ( dev-libs/libhid:= )
	lcd_devices_mdm166a? ( dev-libs/libhid:= )
	lcd_devices_mtc_s16209x? ( dev-libs/libhid:= )
	lcd_devices_mx5000? ( app-misc/mx5000tools )
	lcd_devices_noritakevfd? ( dev-libs/libhid:= )
	lcd_devices_picolcd? ( virtual/libusb:1= )
	lcd_devices_shuttlevfd? ( virtual/libusb:0= )
	lcd_devices_ula200? ( dev-embedded/libftdi:1= )
	lcd_devices_xosd? ( x11-libs/libX11:=
		x11-libs/xosd:= )"

RDEPEND="${DEPEND_LCD_DEVICES}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot]
		app-text/xmlto )
	freetype? ( media-libs/freetype:2= )
	nfs? ( net-fs/nfs-utils )
	png? ( media-libs/libpng:0= )
	samba? ( net-fs/samba )"

DOCS=( "CREDITS.md" "TODO" )

PATCHES=(
	"${FILESDIR}/${P}-fix-parallel-make.patch"
	"${FILESDIR}/${P}-use-freetype2-pkg-config.patch"
)

src_unpack() {
	unpack ${P}.tar.gz

	# Copy missing docbook or the buildung of the lcdproc-user docbook will fail
	cp "${DISTDIR}"/linux_input.docbook "${S}"/docs/lcdproc-user/drivers/linux_input.docbook || die
}

src_prepare() {
	default

	# Fix path for modules
	sed -e "37s:server/drivers:/usr/$(get_libdir)/lcdproc:" -i LCDd.conf || die

	eautoreconf
}

src_configure() {
	# Enable all users enabled lcd devices
	local myeconfargs_lcd_devices
	for lcd_device in "${IUSE_LCD_DEVICES[@]}"; do
		if use "lcd_devices_${lcd_device,,}"; then
			myeconfargs_lcd_devices+=",${lcd_device}"
		fi
	done

	local enable_ftdi="--disable-libftdi"
	if use lcd_devices_glcd || use lcd_devices_hd44780 || use lcd_devices_i2500vfd || use lcd_devices_lis || use lcd_devices_ula200; then
		enable_ftdi="--enable-libftdi"
	fi

	local enable_hid="--disable-libhid"
	if use lcd_devices_cfontz || use lcd_devices_cfontzpacket || use lcd_devices_cwlnx || use lcd_devices_glcd || use lcd_devices_lb216 || use lcd_devices_mdm166a || use lcd_devices_mtc_s16209x || use lcd_devices_noritakevfd; then
		enable_hid="--enable-libhid"
	fi

	local enable_png="--disable-libpng"
	use lcd_devices_glcd && enable_png=""

	local enable_usb0="--disable-libusb"
	if use lcd_devices_futaba || use lcd_devices_g15 || use lcd_devices_glcd || use lcd_devices_hd44780 || use lcd_devices_iowarrior || use lcd_devices_picolcd || use lcd_devices_shuttlevfd; then
		enable_usb0="--enable-libusb"
	fi

	local enable_usb1="--disable-libusb-1-0"
	if use lcd_devices_futaba || use lcd_devices_picolcd; then
		enable_usb1="--enable-libusb-1-0"
	fi

	local enable_x11="--disable-libX11"
	use lcd_devices_glcd && enable_x11="--enable-libX11"

	local myeconfargs=(
		--enable-drivers="${myeconfargs_lcd_devices#,}"
		$(use_enable debug)
		$(use_enable doc doxygen)
		$(use_enable doc dot)
		$(use_enable doc html-dox)
		$(use_enable doc latex-dox)
		$(use_enable ethlcd)
		$(use_enable extra-charmaps)
		$(use_enable freetype)
		$(use_enable menu lcdproc-menus)
		$(use_enable nfs stat-nfs)
		$(use_enable samba stat-smbfs)
		$(use_enable test-menu testmenus)
		${enable_ftdi}
		${enable_hid}
		${enable_png}
		${enable_usb0}
		${enable_usb1}
		${enable_x11}
		--with-lcdport="13666"
		--with-pidfile-dir="/run"
		--without-included-getopt
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc; then
		emake dox

		local docbook
		for docbook in lcdproc-user lcdproc-dev; do
			cd "${S}"/docs/"${docbook}" || die
			xmlto html "${docbook}".docbook || die
		done
	fi
}

src_install() {
	default

	# Move example clients from '/usr/bin' into '/usr/share/lcdproc/clients'
	rm -f "${ED%/}"/usr/bin/{fortune,lcdident,lcdmetar,iosock,tail,x11amp}.pl || die
	insinto /usr/share/lcdproc/clients
	doins clients/examples/*.pl clients/metar/*.pl

	newinitd "${FILESDIR}"/LCDd.initd LCDd
	newinitd "${FILESDIR}"/lcdexec.initd lcdexec
	newinitd "${FILESDIR}"/lcdproc.initd lcdproc

	systemd_dounit "${FILESDIR}"/LCDd.service
	systemd_dounit "${FILESDIR}"/lcdexec.service
	systemd_dounit "${FILESDIR}"/lcdproc.service

	if use doc; then
		dodoc -r docs/html

		local docbook
		for docbook in lcdproc-user lcdproc-dev; do
			docinto "${docbook}"
			dodoc docs/"${docbook}"/*.html
		done
	fi
}
