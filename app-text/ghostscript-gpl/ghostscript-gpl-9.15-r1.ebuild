# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript-gpl/ghostscript-gpl-9.15-r1.ebuild,v 1.10 2015/06/11 14:20:02 ago Exp $

EAPI=5

inherit autotools eutils multilib versionator flag-o-matic

DESCRIPTION="Ghostscript is an interpreter for the PostScript language and for PDF"
HOMEPAGE="http://ghostscript.com/"

MY_P=${P/-gpl}
GSDJVU_PV=1.6
PVM=$(get_version_component_range 1-2)
SRC_URI="
	http://downloads.ghostscript.com/public/${MY_P}.tar.bz2
	mirror://gentoo/${PN}-9.12-patchset-1.tar.bz2
	djvu? ( mirror://sourceforge/djvu/gsdjvu-${GSDJVU_PV}.tar.gz )"

LICENSE="AGPL-3 CPL-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="cups dbus djvu gtk idn linguas_de static-libs X"
RESTRICT="djvu? ( bindist )"

COMMON_DEPEND="
	app-text/libpaper
	media-libs/fontconfig
	>=media-libs/freetype-2.4.9:2=
	media-libs/jbig2dec
	>=media-libs/lcms-2.6:2
	>=media-libs/libpng-1.6.2:0=
	>=media-libs/tiff-4.0.1:0=
	>=sys-libs/zlib-1.2.7:=
	virtual/jpeg:0
	cups? ( >=net-print/cups-1.3.8 )
	dbus? ( sys-apps/dbus )
	djvu? ( app-text/djvu )
	gtk? ( || ( x11-libs/gtk+:3 x11-libs/gtk+:2 ) )
	idn? ( net-dns/libidn )
	X? ( x11-libs/libXt x11-libs/libXext )
"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	>=app-text/poppler-data-0.4.5-r1
	>=media-fonts/urw-fonts-2.4.9
	linguas_ja? ( media-fonts/kochi-substitute )
	linguas_ko? ( media-fonts/baekmuk-fonts )
	linguas_zh_CN? ( media-fonts/arphicfonts )
	linguas_zh_TW? ( media-fonts/arphicfonts )
	!!media-fonts/gnu-gs-fonts-std
	!!media-fonts/gnu-gs-fonts-other
	!<net-print/cups-filters-1.0.36-r2
"

S="${WORKDIR}/${MY_P}"

LANGS="ja ko zh_CN zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

pkg_setup() {
	if use djvu; then
		ewarn "With USE=\"djvu\", distribution of binaries is restricted!"
		ewarn "See http://djvu.sourceforge.net/gsdjvu/COPYING for details on licensing issues."
	fi
}

src_prepare() {
	# remove internal copies of various libraries
	rm -rf "${S}"/cups/libs
	rm -rf "${S}"/expat
	rm -rf "${S}"/freetype
	rm -rf "${S}"/jbig2dec
	rm -rf "${S}"/jpeg{,xr}
	rm -rf "${S}"/lcms{,2}
	rm -rf "${S}"/libpng
	rm -rf "${S}"/tiff
	rm -rf "${S}"/zlib
	# remove internal CMaps (CMaps from poppler-data are used instead)
	rm -rf "${S}"/Resource/CMap

	# apply various patches, many borrowed from Fedora
	# http://pkgs.fedoraproject.org/cgit/ghostscript.git
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes"
	EPATCH_SOURCE="${WORKDIR}/patches/"
	epatch

	if use djvu ; then
		unpack gsdjvu-${GSDJVU_PV}.tar.gz
		cp gsdjvu-${GSDJVU_PV}/gsdjvu "${S}"
		cp gsdjvu-${GSDJVU_PV}/gdevdjvu.c "${S}"/base
		epatch "${WORKDIR}"/patches-gsdjvu/gsdjvu-1.3-${PN}-8.64.patch
		cp "${S}"/contrib/contrib.mak "${S}"/base/contrib.mak.gsdjvu
		grep -q djvusep "${S}"/contrib/contrib.mak || \
			cat gsdjvu-${GSDJVU_PV}/gsdjvu.mak >> "${S}"/contrib/contrib.mak

		# install ps2utf8.ps, bug #197818
		cp gsdjvu-${GSDJVU_PV}/ps2utf8.ps "${S}"/lib
		sed -i -e '/$(EXTRA_INIT_FILES)/ a\ps2utf8.ps \\' \
			"${S}"/base/unixinst.mak || die "sed failed"
	fi

	if ! use gtk ; then
		sed -i -e "s:\$(GSSOX)::" \
			-e "s:.*\$(GSSOX_XENAME)$::" \
			"${S}"/base/unix-dll.mak || die "sed failed"
	fi

	# search path fix
	# put LDFLAGS after BINDIR, bug #383447
	sed -i -e "s:\$\(gsdatadir\)/lib:/usr/share/ghostscript/${PVM}/$(get_libdir):" \
		-e "s:exdir=.*:exdir=/usr/share/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=/usr/share/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=/usr/share/doc/${PF}/html:" \
		-e 's:-L$(BINDIR):& $(LDFLAGS):g' \
		"${S}"/Makefile.in "${S}"/base/*.mak || die "sed failed"

	cd "${S}"
	eautoreconf

	cd "${S}/ijs"
	eautoreconf
}

src_configure() {
	local FONTPATH
	for path in \
		/usr/share/fonts/urw-fonts \
		/usr/share/fonts/Type1 \
		/usr/share/fonts \
		/usr/share/poppler/cMap/Adobe-CNS1 \
		/usr/share/poppler/cMap/Adobe-GB1 \
		/usr/share/poppler/cMap/Adobe-Japan1 \
		/usr/share/poppler/cMap/Adobe-Japan2 \
		/usr/share/poppler/cMap/Adobe-Korea1
	do
		FONTPATH="$FONTPATH${FONTPATH:+:}$path"
	done

	econf \
		--enable-dynamic \
		--enable-freetype \
		--enable-fontconfig \
		--enable-openjpeg \
		--disable-compile-inits \
		--with-drivers=ALL \
		--with-fontpath="$FONTPATH" \
		--with-ijs \
		--with-jbig2dec \
		--with-libpaper \
		--with-system-libtiff \
		--without-lcms \
		--without-luratech \
		$(use_enable cups) \
		$(use_enable dbus) \
		$(use_enable gtk) \
		$(use_with cups pdftoraster) \
		$(use_with idn libidn) \
		$(use_with X x)

	if use djvu ; then
		sed -i -e 's!$(DD)bbox.dev!& $(DD)djvumask.dev $(DD)djvusep.dev!g' \
			"${S}"/Makefile || die "sed failed"
	fi

	cd "${S}/ijs"
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_compile() {
	# -j1 needed because of bug #550926
	emake -j1 so all

	cd "${S}/ijs"
	emake
}

src_install() {
	emake DESTDIR="${D}" install-so install

	if use djvu ; then
		dobin gsdjvu
	fi

	# move gsc to gs, bug #343447
	# gsc collides with gambit, bug #253064
	mv -f "${D}/usr/bin/gsc" "${D}/usr/bin/gs" || die

	cd "${S}/ijs"
	emake DESTDIR="${D}" install

	# rename the original cidfmap to cidfmap.GS
	mv "${D}/usr/share/ghostscript/${PVM}/Resource/Init/cidfmap"{,.GS} || die

	# install our own cidfmap to handle CJK fonts
	insinto "/usr/share/ghostscript/${PVM}/Resource/Init"
	doins "${WORKDIR}/fontmaps/CIDFnmap"
	doins "${WORKDIR}/fontmaps/cidfmap"
	for X in ${LANGS} ; do
		if use linguas_${X} ; then
			doins "${WORKDIR}/fontmaps/cidfmap.${X}"
		fi
	done

	# install the CMaps from poppler-data properly, bug #409361
	dosym /usr/share/poppler/cMaps /usr/share/ghostscript/${PVM}/Resource/CMap

	use static-libs || find "${D}" -name '*.la' -delete

	use linguas_de || rm -r "${D}"/usr/share/man/de
}
