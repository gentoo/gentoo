# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GENTOO_DEPEND_ON_PERL=no

inherit eutils perl-module systemd

if [[ "${PV}" == "9999" ]] ; then
	inherit bzr
	EBZR_REPO_URI="http://bzr.linuxfoundation.org/openprinting/cups-filters"
else
	SRC_URI="http://www.openprinting.org/download/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~m68k-mint"
fi
DESCRIPTION="Cups PDF filters"
HOMEPAGE="https://wiki.linuxfoundation.org/openprinting/pdf_as_standard_print_job_format"

LICENSE="MIT GPL-2"
SLOT="0"
IUSE="dbus +foomatic jpeg ldap perl png +postscript static-libs tiff zeroconf"

RDEPEND="
	postscript? ( >=app-text/ghostscript-gpl-9.09[cups] )
	>=app-text/poppler-0.32:=[cxx,jpeg?,lcms,tiff?,utils,xpdf-headers(+)]
	>=app-text/qpdf-3.0.2:=
	dev-libs/glib:2
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
	ldap? ( net-nds/openldap )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
"

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir="${EPREFIX}"/var \
		--with-cups-rundir="${EPREFIX}"/run/cups \
		$(use_enable dbus) \
		$(use_enable zeroconf avahi) \
		$(use_enable static-libs static) \
		$(use_enable foomatic) \
		$(use_enable ldap) \
		$(use_enable postscript ghostscript) \
		$(use_enable postscript ijs) \
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

	if use postscript; then
		# workaround: some printer drivers still require pstoraster and pstopxl, bug #383831
		dosym gstoraster /usr/libexec/cups/filter/pstoraster
		dosym gstopxl /usr/libexec/cups/filter/pstopxl
	fi

	prune_libtool_files --all

	cp "${FILESDIR}"/cups-browsed.init.d-r1 "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/utils/cups-browsed.service || die
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
