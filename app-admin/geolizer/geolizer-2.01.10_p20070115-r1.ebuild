# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# uses webapp.eclass to create directories with right permissions
# probably slight overkill but works well

EAPI="2"

inherit versionator confutils eutils webapp db-use autotools

WEBAPP_MANUAL_SLOT="yes"

MY_PV="$(get_version_component_range 1-2)-$(get_version_component_range 3)"
WEBALIZER_P="webalizer-${MY_PV}"
GEOLIZER_P="${PN}_${MY_PV}-patch.${PV/*_p/}"

DESCRIPTION="Webserver log file analyzer"
HOMEPAGE="http://sysd.org/stas/node/10"
SRC_URI="ftp://ftp.mrunix.net/pub/webalizer/old/${WEBALIZER_P}-src.tar.bz2
	http://sysd.org/stas/files/active/0/${GEOLIZER_P}.tar.gz
	mirror://gentoo/webalizer.conf.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls"
SLOT="0"

DEPEND=">=sys-libs/db-4.2
	>=sys-libs/zlib-1.1.4
	>=media-libs/libpng-1.2
	>=media-libs/gd-1.8.3
	dev-libs/geoip"

S="${WORKDIR}"/${WEBALIZER_P}

pkg_setup() {
	webapp_pkg_setup
	confutils_require_built_with_all media-libs/gd png

	# USE=nls has no real meaning if LINGUAS isn't set
	if use nls && [[ -z "${LINGUAS}" ]]; then
		ewarn "you must set LINGUAS in /etc/make.conf"
		ewarn "if you want to USE=nls"
		die "please either set LINGUAS or do not use nls"
	fi
}

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${MY_PV}-patch/${PN}.patch \
			"${FILESDIR}"/${P}-etc-geolizer-conf.patch \
			"${FILESDIR}"/${P}-strip.patch
	sed -i configure.in -e 's|libGeoIP.a|libGeoIP.so|g' || die
	eautoreconf
}

src_configure() {
	# really dirty hack; necessary due to a really gross ./configure
	# basically, it just sets the natural language the program uses
	# unfortunatly, this program only allows for one lang, so only the first
	# entry in LINGUAS is used
	if use nls; then
		local longlang="$(grep ^${LINGUAS:0:2} "${FILESDIR}"/geolizer-language-list.txt)"
		local myconf="${myconf} --with-language=${longlang:3}"
	else
		local myconf="${myconf} --with-language=english"
	fi

	econf --enable-dns \
		--with-db=$(db_includedir) \
		--with-dblib=$(db_libname) \
		${myconf} \
		|| die "econf failed"
}

src_install() {
	webapp_src_preinst

	newbin webalizer geolizer
	fperms 755 /usr/bin/geolizer
	dosym geolizer /usr/bin/geozolver || die 'dosym failed'
	newman webalizer.1 geolizer.1 || die 'newman failed'

	insinto /etc
	newins "${WORKDIR}"/webalizer.conf geolizer.conf || die 'doins failed'
	dosed "s/apache/apache2/g" /etc/geolizer.conf || die 'dosed failed'

	dodoc CHANGES *README* INSTALL sample.conf "${FILESDIR}"/apache.geolizer || die 'dodoc failed'

	webapp_src_install
}

pkg_postinst() {
	elog
	elog "It is suggested that you restart apache before using geolizer"
	elog "You may want to review /etc/geolizer.conf and ensure that"
	elog "OutputDir is set correctly"
	elog
	elog "Then just type geolizer to generate your stats."
	elog "You can also use cron to generate them e.g. every day."
	elog "They can be accessed via http://localhost/geolizer"
	elog
	elog "A sample Apache config file has been installed into"
	elog "/usr/share/doc/${PF}/apache.geolizer"
	elog "Please edit and install it as necessary"
	elog

	if [[ ${#LINGUAS} -gt 2 ]] && use nls; then
		ewarn
		ewarn "You have more than one language in LINGUAS"
		ewarn "Due to the limitations of this packge, it was built"
		ewarn "only with ${LINGUAS:0:2} support. If this is not what"
		ewarn "you intended, please place the language you desire"
		ewarn "_first_ in the list of LINGUAS in /etc/make.conf"
		ewarn
	fi

	webapp_pkg_postinst
}
