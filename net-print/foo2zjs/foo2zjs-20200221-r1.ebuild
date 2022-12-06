# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="support for printing to ZjStream-based printers"
HOMEPAGE="https://github.com/koenkooi/foo2zjs"
SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="bindist !test? ( test )"

RDEPEND="
	net-print/cups
	net-print/foomatic-db-engine
	>=net-print/cups-filters-1.0.43-r1[foomatic]
	virtual/udev
"

DEPEND="
	${RDEPEND}
	app-arch/unzip
	app-text/ghostscript-gpl
	app-editors/vim
	net-misc/wget
	sys-apps/ed
	sys-devel/bc
	test? ( sys-process/time )
"

PATCHES=(
		"${FILESDIR}/${PN}-usbbackend.patch"
		"${FILESDIR}/${PN}-udev.patch"
)

src_prepare() {
	# Prevent an access violation.
	sed -e "s~/etc~${D}/etc~g" -i Makefile || die
	sed -e "s~/etc~${D}/etc~g" -i hplj1000 || die

	# Prevent an access violation, do not create symlinks on live file system
	# during installation.
	sed -e 's/ install-filter / /g' -i Makefile || die

	# Prevent an access violation, do not remove files from live filesystem
	# during make install
	sed -e '/rm .*LIBUDEVDIR)\//d' -i Makefile || die
	sed -e '/rm .*lib\/udev\/rules.d\//d' -i hplj1000 || die

	# Fix doc installation warning
	sed -e 's@DOCDIR=$(PREFIX)/share/doc/foo2zjs/@DOCDIR=$(PREFIX)/share/doc/${PF}/@' -i Makefile || die

	default
}

src_compile() {
	MAKEOPTS=-j1 CC="$(tc-getCC)" default
}

src_install() {
	# ppd files are installed automagically. We have to create a directory for them.
	dodir /usr/share/ppd

	emake DESTDIR="${D}" -j1 install install-hotplug
}

src_test() {
	# see bug 419787
	: ;
}
