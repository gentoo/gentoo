# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES='fr'

inherit desktop flag-o-matic plocale toolchain-funcs

MY_PV=$(ver_cut 3 PV/b/B).$(ver_cut 1-3)

DESCRIPTION="Hardware Lister"
HOMEPAGE="https://www.ezix.org/project/wiki/HardwareLiSter"
SRC_URI="https://www.ezix.org/software/files/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="gtk sqlite static"

REQUIRED_USE="static? ( !gtk !sqlite )"

DEPEND="${RDEPEND}"
RDEPEND="sys-apps/hwids
	gtk? ( x11-libs/gtk+:2 )
	sqlite? ( dev-db/sqlite:3 )"
BDEPEND="gtk? ( virtual/pkgconfig )
	sqlite? ( virtual/pkgconfig )"

S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=( COPYING README.md docs/{Changelog,TODO,IODC.txt,lshw.xsd,proc_usb_info.txt} )

src_prepare() {
	default

	plocale_find_changes "src/po" "" ".po" || die
	sed -i \
		-e "/^LANGUAGES =/ s/=.*/= $(plocale_get_locales)/" \
		src/po/Makefile || die
	sed -i \
		-e 's:\<pkg-config\>:${PKG_CONFIG}:' \
		-e 's:+\?make -C:${MAKE} -C:' \
		-e '/^CXXFLAGS/s:=-g: +=:' \
		-e '/^CXXFLAGS/s:-g ::' \
		-e '/^LDFLAGS/s: -g::' \
		-e '/^all:/s: $(DATAFILES)::' \
		-e '/^install:/s: all::' \
		src/Makefile src/gui/Makefile || die
	sed -i \
		-e '/^CXXFLAGS/s:\?=-g: +=:' \
		-e '/^LDFLAGS=/d' \
		src/core/Makefile || die
	sed -i \
		-e '/^#define PCIID_PATH/s:DATADIR"\/pci.ids.*:"/usr/share/misc/pci.ids":' \
		src/core/pci.cc || die
	sed -i \
		-e '/^#define USBID_PATH/s:DATADIR"\/usb.ids.*:"/usr/share/misc/usb.ids":' \
		src/core/usb.cc || die
}

src_compile() {
	tc-export CC CXX AR PKG_CONFIG
	use static && append-ldflags -static

	# Need two sep make statements to avoid parallel build issues. #588174
	local sqlite=$(usex sqlite 1 0)
	emake VERSION=${MY_PV} SQLITE=${sqlite} all
	use gtk && emake SQLITE=${sqlite} gui
}

src_install() {
	emake VERSION=${MY_PV} DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install $(usex gtk 'install-gui' '')
	if use gtk ; then
		newicon -s scalable src/gui/artwork/logo.svg gtk-lshw.svg
		make_desktop_entry \
			"${EPREFIX}"/usr/sbin/gtk-lshw \
			"${DESCRIPTION}"
	fi
}
