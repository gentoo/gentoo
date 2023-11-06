# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Support for printing to ZjStream-based printers"
HOMEPAGE="https://www.quirinux.org"
SRC_URI="https://www.quirinux.org/printers/${P}.tar.gz"

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
	app-editors/vim
	net-misc/wget
	sys-apps/ed
	sys-devel/bc
	test? ( sys-process/time )
"

PATCHES=(
	"${FILESDIR}/${PN}-replace-etc-with-destdir-etc.patch"
	"${FILESDIR}/${PN}-udev.patch"
	"${FILESDIR}/${PN}-usbbackend.patch"
)

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	# Prevent an access violation, do not create symlinks on live file system
	# during installation.
	sed -e 's/ install-filter / /g' -i Makefile || die "Failed to sed Makefile"

	# Prevent an access violation, do not remove files from live filesystem
	# during make install
	sed -e '/rm .*LIBUDEVDIR)\//d' -i Makefile || die "Failed to sed Makefile"
	sed -e '/rm .*lib\/udev\/rules.d\//d' -i hplj1000 || die "Failed to sed hplj1000"
}

src_compile() {
	MAKEOPTS=-j1 CC="$(tc-getCC)" default
}

src_install() {
	# ppd files are installed automagically. We have to create a directory
	# for them.
	dodir /usr/share/ppd

	emake DESTDIR="${D}" -j1 install install-hotplug
}

src_test() {
	# see bug 419787
	: ;
}
