# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ca es fr"

inherit desktop flag-o-matic plocale toolchain-funcs xdg-utils

MY_COMMIT=42fef565731411a784101de614a54bff79d1858e
MY_PV=$(ver_cut 3 PV/b/B).$(ver_cut 1-3)_$(ver_cut 5-6)

DESCRIPTION="Hardware Lister"
HOMEPAGE="https://www.ezix.org/project/wiki/HardwareLiSter"
SRC_URI="https://ezix.org/src/pkg/lshw/archive/${MY_COMMIT}.tar.gz -> ${P}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="gtk sqlite static"

REQUIRED_USE="static? ( !gtk !sqlite )"

DEPEND="${RDEPEND}"
RDEPEND="sys-apps/hwdata
	gtk? ( x11-libs/gtk+:3 )
	sqlite? ( dev-db/sqlite:3 )"
BDEPEND="gtk? ( virtual/pkgconfig )
	sqlite? ( virtual/pkgconfig )"

S=${WORKDIR}/${PN}

DOCS=( COPYING README.md docs/{Changelog,TODO,IODC.txt,lshw.xsd,proc_usb_info.txt} )

PATCHES=( "${FILESDIR}"/lshw-02.19.2b-respect-LDFLAGS.patch )

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
		-e '/^#define PCIID_PATH/s:DATADIR"\/pci.ids.*:"/usr/share/hwdata/pci.ids":' \
		src/core/pci.cc || die
	sed -i \
		-e '/^#define USBID_PATH/s:DATADIR"\/usb.ids.*:"/usr/share/hwdata/usb.ids":' \
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
		newicon -s scalable src/gui/artwork/logo.svg lshw.svg
		make_desktop_entry \
			"${EPREFIX}"/usr/sbin/gtk-lshw \
			"${DESCRIPTION}"
	fi
}

pkg_postinst() {
	if use gtk ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gtk ; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
