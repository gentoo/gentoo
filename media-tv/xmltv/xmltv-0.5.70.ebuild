# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Set of utilities to manage TV listings stored in the XMLTV format"
HOMEPAGE="http://xmltv.org"
SRC_URI="mirror://sourceforge/xmltv/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~x86-linux"

IUSE="ar ch_search dk dtvla es_laguiatv eu_dotmedia eu_epg fi fi_sv
fr fr_kazer huro il is it na_dd na_dtv na_tvmedia nl no_gf pt_meo se_swedb
se_tvzon tr uk_bleb uk_tvguide tv_check tv_combiner tv_pick_cgi zz_sdjson"

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
	dev-perl/XML-LibXML
	dev-perl/XML-TreePP
"
DEPEND="${RDEPEND}
	ar? ( dev-perl/HTML-Tree >=dev-perl/HTML-Parser-3.34 dev-perl/HTTP-Cookies dev-perl/TimeDate )
	ch_search? ( dev-perl/HTML-Tree >=dev-perl/HTML-Parser-3.34 )
	dk? ( dev-perl/JSON dev-perl/IO-stringy dev-perl/DateTime )
	dtvla? ( dev-perl/HTML-Tree dev-perl/HTTP-Cookies dev-perl/TimeDate )
	es_laguiatv? ( dev-perl/HTML-Tree )
	eu_dotmedia? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	eu_epg? ( dev-perl/Archive-Zip dev-perl/DateTime-Format-Strptime >=dev-perl/HTML-Parser-3.34 dev-perl/IO-stringy )
	fi? ( dev-perl/HTML-Tree )
	fi_sv? ( dev-perl/IO-stringy dev-perl/HTML-Tree dev-perl/DateTime )
	fr? ( dev-perl/DateTime-TimeZone dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 )
	huro? ( dev-perl/HTML-Tree )
	is? ( dev-perl/XML-DOM dev-perl/XML-LibXSLT )
	na_dd? ( dev-perl/SOAP-Lite )
	na_dtv? ( >=dev-perl/HTML-Parser-3.34 dev-perl/DateTime dev-perl/HTTP-Cookies )
	na_tvmedia? ( dev-perl/XML-LibXML )
	nl? ( dev-perl/HTTP-Cache-Transparent dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 dev-perl/TimeDate )
	pt_meo? ( dev-perl/XML-LibXML dev-perl/DateTime )
	se_swedb? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	se_tvzon? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	tr? ( dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/HTTP-Cookies dev-perl/TimeDate )
	uk_bleb? ( dev-perl/IO-stringy dev-perl/Archive-Zip )
	uk_tvguide? ( dev-perl/HTML-Tree dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/TimeDate )
	zz_sdjson? ( dev-perl/DateTime-Format-ISO8601 virtual/perl-Digest-SHA dev-perl/JSON dev-perl/List-MoreUtils dev-perl/libwww-perl virtual/perl-Storable dev-perl/Try-Tiny )
	tv_check? ( dev-perl/Tk dev-perl/Tk-TableMatrix )
	tv_combiner? ( dev-perl/XML-LibXML )
"

PREFIX="/usr"

pkg_setup() {
	# Uses Data::Manip in various places which can fail
	# if TZ is still set to Factory as it is in stock gentoo
	# install media
	export TZ=UTC
}

src_prepare() {
	default

	sed -i \
		-e "s:\$VERSION = '${PV}':\$VERSION = '${PVR}':" \
		-e "/^@docs/s:doc/COPYING ::" \
		Makefile.PL || die
}

src_configure() {
	make_config() {
		# Never except default configuration
		echo "no"

		# Enable Agentina
		usex ar
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
		# Enable Hungary and Romania
		usex huro
		# Enable Israel
		usex il
		# Enable Iceland
		usex is
		# Enable Italy
		usex it
		# Enable Italy from DVB-S stream
		echo "no" # missing Linux::DVB
		# Enable North America using DataDirect
		usex na_dd
		# Enable North America from directv.com
		usex na_dtv
		# Enable North America XMLTVListings.com
		usex na_tvmedia
		# Enable Netherlands
		usex nl
		# Enable Portugal EPG from sappo.pt
		usex pt_meo
		# Enable Sweden
		usex se_swedb
		# Enable Sweeden Alternative
		usex se_tvzon
		# Enable Turkey
		usex tr
		# Enable UK fast alternative grabber
		usex uk_bleb
		# Enable UK/Ireland TV Guide
		usex uk_tvguide
		# Enable Schedules Direct JSON
		usex zz_sdjson
		# Enable Schedules Direct JSON (SQLite version)
		echo "no" # TODO
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

	local i
	for i in $(grep -rl "${D}" "${D}"); do
		sed -e "s:${D}::g" -i "${i}" || die
	done

	if use tv_pick_cgi; then
		dobin choose/tv_pick/tv_pick_cgi
	fi
}

pkg_postinst() {
	if use tv_pick_cgi; then
		elog "To use tv_pick_cgi, please link it from /usr/bin/tv_pick_cgi"
		elog "to where the ScriptAlias directive is configured."
	fi
}
