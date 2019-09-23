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

IUSE="ar ch-search dk dtvla es-laguiatv eu-dotmedia eu-epg fi fi-sv
fr fr-kazer huro il is it na-dd na-dtv na-tvmedia nl no-gf pt-meo se-swedb
se-tvzon tr uk-bleb uk-tvguide tv-check tv-combiner tv-pick-cgi zz-sdjson"

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
	ch-search? ( dev-perl/HTML-Tree >=dev-perl/HTML-Parser-3.34 )
	dk? ( dev-perl/JSON dev-perl/IO-stringy dev-perl/DateTime )
	dtvla? ( dev-perl/HTML-Tree dev-perl/HTTP-Cookies dev-perl/TimeDate )
	es-laguiatv? ( dev-perl/HTML-Tree )
	eu-dotmedia? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	eu-epg? ( dev-perl/Archive-Zip dev-perl/DateTime-Format-Strptime >=dev-perl/HTML-Parser-3.34 dev-perl/IO-stringy )
	fi? ( dev-perl/HTML-Tree )
	fi-sv? ( dev-perl/IO-stringy dev-perl/HTML-Tree dev-perl/DateTime )
	fr? ( dev-perl/DateTime-TimeZone dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 )
	huro? ( dev-perl/HTML-Tree )
	is? ( dev-perl/XML-DOM dev-perl/XML-LibXSLT )
	na-dd? ( dev-perl/SOAP-Lite )
	na-dtv? ( >=dev-perl/HTML-Parser-3.34 dev-perl/DateTime dev-perl/HTTP-Cookies )
	na-tvmedia? ( dev-perl/XML-LibXML )
	nl? ( dev-perl/HTTP-Cache-Transparent dev-perl/HTML-Tree dev-perl/DateTime >=dev-perl/HTML-Parser-3.34 dev-perl/TimeDate )
	pt-meo? ( dev-perl/XML-LibXML dev-perl/DateTime )
	se-swedb? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	se-tvzon? ( dev-perl/XML-LibXML dev-perl/IO-stringy dev-perl/HTTP-Cache-Transparent )
	tr? ( dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/HTTP-Cookies dev-perl/TimeDate )
	uk-bleb? ( dev-perl/IO-stringy dev-perl/Archive-Zip )
	uk-tvguide? ( dev-perl/HTML-Tree dev-perl/URI dev-perl/HTTP-Cache-Transparent dev-perl/DateTime dev-perl/TimeDate )
	zz-sdjson? ( dev-perl/DateTime-Format-ISO8601 virtual/perl-Digest-SHA dev-perl/JSON dev-perl/List-MoreUtils dev-perl/libwww-perl virtual/perl-Storable dev-perl/Try-Tiny )
	tv-check? ( dev-perl/Tk dev-perl/Tk-TableMatrix )
	tv-combiner? ( dev-perl/XML-LibXML )
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
		usex ch-search
		# Enable Denmark
		usex dk
		# Enable Latin America
		usex dtvla
		# Enable Spain
		usex es-laguiatv
		# Enable EU xmltv.se
		usex eu-dotmedia
		# Enable EU epgdata.com
		usex eu-epg
		# Enable Finland
		usex fi
		# Enable Swedish listings in Finland
		usex fi-sv
		# Enable France
		usex fr
		# Enable France EPG from kazer.org
		usex fr-kazer
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
		usex na-dd
		# Enable North America from directv.com
		usex na-dtv
		# Enable North America XMLTVListings.com
		usex na-tvmedia
		# Enable Netherlands
		usex nl
		# Enable Portugal EPG from sappo.pt
		usex pt-meo
		# Enable Sweden
		usex se-swedb
		# Enable Sweeden Alternative
		usex se-tvzon
		# Enable Turkey
		usex tr
		# Enable UK fast alternative grabber
		usex uk-bleb
		# Enable UK/Ireland TV Guide
		usex uk-tvguide
		# Enable Schedules Direct JSON
		usex zz-sdjson
		# Enable Schedules Direct JSON (SQLite version)
		echo "no" # TODO
		# Enable GUI checking.
		usex tv-check
		# Enable combiner
		usex tv-combiner
		# Enable CGI support
		usex tv-pick-cgi
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

	if use tv-pick-cgi; then
		dobin choose/tv_pick/tv_pick_cgi
	fi
}

pkg_postinst() {
	if use tv-pick-cgi; then
		elog "To use tv_pick_cgi, please link it from /usr/bin/tv_pick_cgi"
		elog "to where the ScriptAlias directive is configured."
	fi
}
