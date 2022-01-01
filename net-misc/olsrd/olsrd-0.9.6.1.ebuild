# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs versionator

DESCRIPTION="An implementation of the Optimized Link State Routing protocol"
HOMEPAGE="http://www.olsr.org/"
SRC_URI="http://www.olsr.org/releases/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk pud"

DEPEND="
	virtual/pkgconfig
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	pud? ( sci-geosciences/gpsd )
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0.2-gtk.patch
	"${FILESDIR}"/${PN}-0.9.6-gpsd.patch
)

src_prepare() {
	default

	# fix parallel make
	# respect AR
	# verbose build
	# fix default prefix, bug #453440
	sed -i \
		-e '/@echo "\[/d' \
		-e 's|$(MAKECMD)|$(MAKE)|g' \
		-e 's|@$(CC)|$(CC)|g' \
		-e 's|@ar |$(AR) |g' \
		-e '/^prefix/s:/usr/local:/usr:' \
		$( find . -name 'Makefile*' ) || die

	# respect LDFLAGS
	sed -i \
		-e 's|$(CC)|& $(OLSRD_LDFLAGS)|g' \
		lib/pud/nmealib/Makefile lib/pud/wireformat/Makefile || die
}

src_configure() {
	if ! use pud; then
		sed -i -e '/^SUBDIRS/ s|pud||g' Makefile || die
	fi
}

src_compile() {
	tc-export PKG_CONFIG
	emake \
		CC="$(tc-getCC)" \
		VERBOSE=1 \
		LIBDIR="/usr/$(get_libdir)/${PN}" \
		OLSRD_LDFLAGS="${LDFLAGS}" \
		OS=linux \
		build_all

	if use gtk; then
		emake -C gui/linux-gtk LIBDIR="/usr/$(get_libdir)/${PN}" CC="$(tc-getCC)"
	fi
}

src_install() {
	emake OS=linux LIBDIR="${D}/usr/$(get_libdir)/${PN}" \
		DESTDIR="${D}" STRIP=true install_all

	if use gtk; then
		emake -C gui/linux-gtk \
			LIBDIR="${D}/usr/$(get_libdir)/${PN}" DESTDIR="${D}" install
	fi

	doinitd "${FILESDIR}/${PN}"

	dodoc CHANGELOG \
		valgrind-howto.txt files/olsrd.conf.default.rfc \
		files/olsrd.conf.default.lq \
		lib/arprefresh/README_ARPREFRESH \
		lib/bmf/README_BMF \
		lib/dot_draw/README_DOT_DRAW \
		lib/dyn_gw/README_DYN_GW \
		lib/dyn_gw_plain/README_DYN_GW_PLAIN \
		lib/httpinfo/README_HTTPINFO \
		lib/mini/README_MINI \
		lib/nameservice/README_NAMESERVICE \
		lib/pgraph/README_PGRAPH \
		lib/quagga/README_QUAGGA \
		lib/secure/README_SECURE \
		lib/txtinfo/README_TXTINFO \
		lib/watchdog/README_WATCHDOG
}
