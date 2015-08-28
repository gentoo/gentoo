# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GENTOO_DEPEND_ON_PERL=no

inherit base eutils perl-module autotools systemd

if [[ "${PV}" == "9999" ]] ; then
	inherit bzr
	EBZR_REPO_URI="http://bzr.linuxfoundation.org/openprinting/cups-filters"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc64 sparc x86"
else
	SRC_URI="http://www.openprinting.org/download/${PN}/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~m68k-mint"
fi
DESCRIPTION="Cups PDF filters"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/openprinting/pdfasstandardprintjobformat"

LICENSE="MIT GPL-2"
SLOT="0"
IUSE="dbus +foomatic jpeg perl png static-libs tiff zeroconf"

RDEPEND="
	>=app-text/ghostscript-gpl-9.09
	<app-text/poppler-0.35.0:=[cxx,jpeg?,lcms,tiff?,xpdf-headers(+)]
	>=app-text/qpdf-3.0.2:=
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	>=net-print/cups-1.7.3
	!<=net-print/cups-1.5.9999
	sys-devel/bc
	sys-libs/zlib
	dbus? ( sys-apps/dbus )
	foomatic? ( !net-print/foomatic-filters )
	jpeg? ( virtual/jpeg:0 )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.0.71-poppler0340.patch" )

src_prepare() {
	base_src_prepare
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable dbus) \
		$(use_enable zeroconf avahi) \
		$(use_enable static-libs static) \
		--with-fontdir="fonts/conf.avail" \
		--with-pdftops=pdftops \
		--enable-imagefilters \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff) \
		--with-rcdir=no \
 		--with-browseremoteprotocols=DNSSD,CUPS \
		--without-php
}

src_compile() {
	MAKEOPTS=-j1 default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_configure
		perl-module_src_compile
		popd > /dev/null
	fi
}

src_install() {
	default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_install
		perl_delete_localpod
		popd > /dev/null
	fi

	# workaround: some printer drivers still require pstoraster and pstopxl, bug #383831
	dosym /usr/libexec/cups/filter/gstoraster /usr/libexec/cups/filter/pstoraster
	dosym /usr/libexec/cups/filter/gstopxl /usr/libexec/cups/filter/pstopxl

	prune_libtool_files --all

	cp "${FILESDIR}"/cups-browsed.init.d "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/utils/cups-browsed.service || die
	fi

	if ! use foomatic ; then
		# this needs an upstream solution / configure switch
		rm -v "${ED}/usr/bin/foomatic-rip" || die
		rm -v "${ED}/usr/libexec/cups/filter/foomatic-rip" || die
		rm -v "${ED}/usr/share/man/man1/foomatic-rip.1" || die
	fi

	doinitd "${T}"/cups-browsed
	systemd_dounit "${S}/utils/cups-browsed.service"
}

pkg_postinst() {
	if ! use foomatic ; then
		ewarn "You are disabling the foomatic code in cups-filters. Please do that ONLY if absolutely."
		ewarn "necessary. net-print/foomatic-filters as replacement is deprecated and unmaintained."
	fi
}
