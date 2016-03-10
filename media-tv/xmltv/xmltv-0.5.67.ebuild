# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-module

DESCRIPTION="Set of utilities to manage TV listings stored in the XMLTV format"
HOMEPAGE="http://xmltv.org"
SRC_URI="mirror://sourceforge/xmltv/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux"

IUSE="ar ch_search dk dtvla es_laguiatv eu_dotmedia eu_egon eu_epg fi fi_sv
fr fr_kazer hr huro il is it na_dd na_dtv na_tvmedia nl no_gf pt pt_meo se_swedb
se_tvzon tr uk_atlas uk_bleb uk_rt uk_tvguide tv_check tv_combiner tv_pick_cgi"

# NOTE: you can customize the xmltv installation by
#       defining USE FLAGS (custom ones in
#	/etc/portage/package.use for example).
#
#	Do "equery u media-tv/xmltv" for the complete
#	list of the flags you can set, with description.

# EXAMPLES:
# enable just North American grabber
#  in /etc/portage/package.use : media-tv/xmltv na_dd
#
# enable graphical front-end, Italy grabber
#  in /etc/portage/package.use : media-tv/xmltv tv_check it

RDEPEND=">=dev-perl/libwww-perl-5.65
	>=dev-perl/XML-Parser-2.34
	>=dev-perl/XML-Twig-3.10
	>=dev-perl/Date-Manip-5.42
	>=dev-perl/XML-Writer-0.6
	virtual/perl-Memoize
	virtual/perl-Storable
	>=dev-perl/Lingua-Preferred-0.2.4
	>=dev-perl/Term-ProgressBar-2.03
	virtual/perl-IO-Compress
	dev-perl/Unicode-String
	dev-perl/TermReadKey
	dev-perl/File-Slurp
	>=dev-lang/perl-5.6.1
	dev-perl/XML-LibXML"
DEPEND="${RDEPEND}
	ar? ( dev-perl/HTML-Tree >=dev-perl/HTML-Parser-3.34 dev-perl/HTTP-Cookies dev-perl/TimeDate )
	ch_search? ( dev-perl/HTML-Tree >=dev-perl/HTML-Parser-3.34 )
	dk? ( dev-perl/JSON dev-perl/IO-stringy dev-perl/DateTime )
	dtvla? ( dev-perl/HTML-Tree dev-perl/HTTP-Cookies dev-perl/TimeDate )
	es_laguiatv? ( dev-perl/HTML-Tree )
	eu_dotmedia? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	eu_egon? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	eu_epg? ( dev-perl/Archive-Zip dev-perl/DateTime-Format-Strptime >=dev-perl/HTML-Parser-3.34 )
	fi? ( dev-perl/HTML-Tree )
	fi_sv? ( dev-perl/IO-stringy dev-perl/HTML-Tree dev-perl/DateTime )
	fr? ( dev-perl/DateTime-TimeZone dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 )
	hr? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	huro? ( dev-perl/HTML-Tree )
	is? ( dev-perl/XML-DOM dev-perl/XML-LibXSLT )
	na_dd? ( dev-perl/SOAP-Lite )
	na_dtv? ( >=dev-perl/HTML-Parser-3.34 dev-perl/DateTime dev-perl/HTTP-Cookies )
	na_tvmedia? ( dev-perl/XML-LibXML )
	nl? ( dev-perl/HTTP-Cache-Transparent dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 dev-perl/TimeDate )
	no_gf? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	pt? ( dev-perl/HTML-Tree dev-perl/HTTP-Cache-Transparent >=dev-perl/HTML-Parser-3.34 dev-perl/DateTime )
	pt_meo? ( dev-perl/XML-LibXML dev-perl/DateTime )
	se_swedb? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	se_tvzon? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	tr? ( dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/HTTP-Cookies dev-perl/TimeDate )
	uk_atlas? ( dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/HTTP-Cookies dev-perl/TimeDate )
	uk_bleb? ( dev-perl/IO-stringy dev-perl/Archive-Zip )
	uk_rt? ( dev-perl/DateTime-TimeZone dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 )
	uk_tvguide? ( dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/TimeDate )
	tv_check? ( dev-perl/perl-tk dev-perl/Tk-TableMatrix )
	tv_combiner? ( dev-perl/XML-LibXML )
"

PREFIX="/usr"

src_prepare() {
	sed -i \
		-e "s:\$VERSION = '${PV}':\$VERSION = '${PVR}':" \
		-e "/^@docs/s:doc/COPYING ::" \
		Makefile.PL || die

	epatch_user
}

src_configure() {
	make_config() {
		# Never except default configuration
		echo "no"

		# Enable Australian
		#use au && echo "yes" || echo "no"
		# Enable Agentina
		usex ar
		# Enable Brazil
		#use br && echo "yes" || echo "no"
		# Enable Brazil Cable
		#use brnet && echo "yes" || echo "no"
		# Enable Switzerland Search
		usex ch_search
		# Enable Denmark
		usex dk
		# Enable Latin America
		usex dtvla
		# Enable Spain
		usex es_laguiatv
		# Enable EU xmltv.se
		usex eu_dotmedia
		# Enable EU German speaking area
		usex eu_egon
		# Enable EU epgdata.com
		usex eu_epg
		# Enable Finland
		usex fi
		# Enable Swedish listings in Finland
		usex fi_sv
		# Enable France
		usex fr
		# Enable France EPG from kazer.org
		usex fr_kazer
		# Enable Belgium and Luxemburg
		#use be && echo "yes" || echo "no"
		#Enable Croatia
		usex hr
		# Enable Hungary and Romania
		usex huro
		# Enable Israel
		usex il
		# Enable Norway Gfeed
		usex is
		# Enable Italy
		usex it
		# Enable Italy from DVB-S stream
		echo "no" # missing Linux::DVB
		# Enable India (experimental)
		# Disabled upstream
		# usex in
		# Enable North America using DataDirect
		usex na_dd
		# Enable North America from directv.com
		usex na_dtv
		# Enable North America XMLTVListings.com
		usex na_tvmedia
		# Enable Netherlands
		usex nl
		# Enable Norway
		usex no_gf
		# Enable Portugal
		usex pt
		# Enable Portugal EPG from sappo.pt
		usex pt_meo
		# Enable Sweden
		usex se_swedb
		# Enable Sweeden Alternative
		usex se_tvzon
		# Enable Turkey
		usex tr
		# Enable UK/Ireland Fast grabber
		usex uk_atlas
		# Enable UK fast alternative grabber
		usex uk_bleb
		# Enable UK/Ireland Radio Times
		usex uk_rt
		# Enable UK/Ireland TV Guide
		usex uk_tvguide
		# Enable GUI checking.
		usex tv_check
		# Enable combiner
		usex tv_combiner
		# Enable CGI support
		usex tv_pick_cgi
	}

	pm_echovar=`make_config`
	perl-module_src_configure
}

src_install() {
	# actually make test should be unneeded, but if non na grabbers
	# start to not install remove comment below
	#make test
	#make

	# to bypass build issue
	#make DESTDIR=${D} install || die "error installing"

	perl-module_src_install

	for i in `grep -rl "${D}" "${D}"` ; do
		sed -e "s:${D}::g" -i "${i}" || die
	done

	if use tv_pick_cgi ; then
		dobin choose/tv_pick/tv_pick_cgi
	fi
}

pkg_postinst() {
	if use tv_pick_cgi ; then
		elog "To use tv_pick_cgi, please link it from /usr/bin/tv_pick_cgi"
		elog "to where the ScriptAlias directive is configured."
	fi
}
