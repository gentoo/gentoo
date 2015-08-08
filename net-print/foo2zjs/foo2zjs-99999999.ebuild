# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Support for printing to ZjStream-based printers"
HOMEPAGE="http://foo2zjs.rkkda.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

RESTRICT="bindist"

RDEPEND="net-print/cups
	net-print/foomatic-db-engine
	|| ( >=net-print/cups-filters-1.0.43-r1[foomatic] net-print/foomatic-filters )
	virtual/udev"
DEPEND="${RDEPEND}
	app-arch/unzip
	app-editors/vim
	net-misc/wget
	sys-apps/ed
	sys-devel/bc
	test? ( sys-process/time )"

S="${WORKDIR}/${PN}"

src_unpack() {
	einfo "Fetching ${PN} tarball"
	wget "http://foo2zjs.rkkda.com/${PN}.tar.gz"
	tar zxf "${WORKDIR}/${PN}.tar.gz"

	epatch "${FILESDIR}/${PN}-udev.patch"
	epatch "${FILESDIR}/${PN}-usbbackend.patch"

	cd "${S}"

	einfo "Fetching additional files (firmware, etc)"
	emake getweb

	# Display wget output, downloading takes some time.
	sed -e '/^WGETOPTS/s/-q//g' -i getweb

	./getweb all
}

src_prepare() {
	# Prevent an access violation.
	sed -e "s~/etc~${D}/etc~g" -i Makefile
	sed -e "s~/etc~${D}/etc~g" -i hplj1000

	# Prevent an access violation, do not create symlinks on live file system
	# during installation.
	sed -e 's/ install-filter / /g' -i Makefile

	# Prevent an access violation, do not remove files from live filesystem
	# during make install
	sed -e '/rm .*LIBUDEVDIR)\//d' -i Makefile
	sed -e '/rm .*lib\/udev\/rules.d\//d' -i hplj1000
}

src_compile() {
	MAKEOPTS=-j1 default
}

src_install() {
	# ppd files are installed automagically. We have to create a directory
	# for them.
	mkdir -p "${D}/usr/share/ppd"

	emake DESTDIR="${D}" -j1 install install-hotplug
}
