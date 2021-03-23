# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES='fr'

inherit desktop flag-o-matic toolchain-funcs l10n

MY_COMMIT="fdab06ac0b190ea0aa02cd468f904ed69ce0d9f1"
MY_P=${PN}-$(ver_cut 3 PV/b/B).$(ver_cut 1-3)_$(ver_cut 5-6)

DESCRIPTION="Hardware Lister"
HOMEPAGE="https://www.ezix.org/project/wiki/HardwareLiSter"
SRC_URI="https://ezix.org/src/pkg/lshw/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk sqlite static"

REQUIRED_USE="static? ( !gtk !sqlite )"

DEPEND="${RDEPEND}"
RDEPEND="sys-apps/hwids
	gtk? ( x11-libs/gtk+:3 )
	sqlite? ( dev-db/sqlite:3 )"
BDEPEND="gtk? ( virtual/pkgconfig )
	sqlite? ( virtual/pkgconfig )"

S=${WORKDIR}/${PN}

DOCS=( COPYING README.md docs/{Changelog,TODO,IODC.txt,lshw.xsd,proc_usb_info.txt} )

src_prepare() {
	default

	l10n_find_plocales_changes "src/po" "" ".po" || die
	sed -i \
		-e "/^LANGUAGES =/ s/=.*/= $(l10n_get_locales)/" \
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
	emake SQLITE=${sqlite} all
	use gtk && emake SQLITE=${sqlite} gui
}

src_install() {
	default
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install $(usex gtk 'install-gui' '')
	if use gtk ; then
		newicon -s scalable src/gui/artwork/logo.svg gtk-lshw.svg
		make_desktop_entry \
			"${EPREFIX}"/usr/sbin/gtk-lshw \
			"${DESCRIPTION}"
	fi
}
