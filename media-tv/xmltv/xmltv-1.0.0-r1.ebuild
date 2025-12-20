# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Set of utilities to manage TV listings stored in the XMLTV format"
HOMEPAGE="http://wiki.xmltv.org/index.php/XMLTVProject https://github.com/XMLTV/xmltv"
SRC_URI="https://github.com/XMLTV/xmltv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc x86"

IUSE="ar ch-search eu-epgdata eu-xmltvse fi fi-sv fr
huro is it it-dvb na-dd na-dtv na-tvmedia pt-vodafone tr
tv-check tv-combiner tv-pick-cgi uk-tvguide zz-sdjson zz-sdjson-sqlite"

RDEPEND="
	dev-perl/Date-Manip
	dev-perl/File-Slurp
	dev-perl/JSON
	dev-perl/Lingua-Preferred
	dev-perl/LWP-Online
	dev-perl/PerlIO-gzip
	dev-perl/Term-ProgressBar
	dev-perl/TermReadKey
	dev-perl/XML-LibXML
	dev-perl/XML-Parser
	dev-perl/XML-TreePP
	dev-perl/XML-Twig
	dev-perl/XML-Writer
	dev-perl/Unicode-String
	virtual/perl-Storable
	virtual/perl-IO-Compress
	ar? (
		dev-perl/DateTime
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
		dev-perl/HTTP-Cookies
	)
	ch-search? (
		dev-perl/HTML-Tree
		dev-perl/HTML-Parser
		dev-perl/HTTP-Cookies
		dev-perl/URI
	)
	eu-epgdata? (
		dev-perl/Archive-Zip
		dev-perl/DateTime
		dev-perl/DateTime-Format-Strptime
		dev-perl/HTML-Parser
		dev-perl/HTTP-Message
	)
	eu-xmltvse? (
		dev-perl/HTTP-Cache-Transparent
		dev-perl/IO-stringy
	)
	fi? (
		dev-perl/HTML-Tree
		dev-perl/LWP-Protocol-https
		dev-perl/URI
	)
	fi-sv? (
		dev-perl/DateTime
		dev-perl/HTML-Tree
		dev-perl/IO-stringy
	)
	fr? (
		dev-perl/DateTime
		dev-perl/DateTime-TimeZone
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
	)
	huro? (
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
	)
	is? (
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
		dev-perl/URI
		dev-perl/XML-DOM
		dev-perl/XML-LibXSLT
	)
	it? (
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
		dev-perl/URI
	)
	it-dvb? (
		virtual/perl-Data-Dumper
	)
	na-dd? (
		dev-perl/HTTP-Daemon
		dev-perl/SOAP-Lite
	)
	na-dtv? (
		dev-perl/DateTime
		dev-perl/HTTP-Cookies
		dev-perl/URI
	 )
	pt-vodafone? (
		dev-perl/DateTime
		dev-perl/URI
	)
	tr? (
		dev-perl/DateTime
		dev-perl/HTTP-Cache-Transparent
		dev-perl/HTTP-Cookies
		dev-perl/URI
	)
	uk-tvguide? (
		dev-perl/DateTime
		dev-perl/HTML-Tree
		dev-perl/HTTP-Cache-Transparent
		dev-perl/HTTP-Cookies
		dev-perl/URI
	)
	zz-sdjson? (
		dev-lang/perl
		dev-perl/DateTime
		virtual/perl-Digest-SHA
		dev-perl/HTTP-Message
		dev-perl/LWP-Protocol-https
		dev-perl/Try-Tiny
	)
	zz-sdjson-sqlite? (
		dev-lang/perl
		dev-perl/DateTime
		dev-perl/DateTime-Format-ISO8601
		dev-perl/DateTime-Format-SQLite
		dev-perl/DateTime-TimeZone
		dev-perl/DBD-SQLite
		dev-perl/DBI
		virtual/perl-Digest-SHA
		dev-perl/File-HomeDir
		dev-perl/File-Which
		dev-perl/List-MoreUtils
		dev-perl/LWP-UserAgent-Determined
	)
	tv-check? (
		dev-perl/Tk
		dev-perl/Tk-TableMatrix
	)
	tv-pick-cgi? ( dev-perl/CGI )
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
	# Add revision number to version info.
	# Remove the doc/COPYING file from documentation.
	sed -i \
		-e "s:\$VERSION = '${PV}':\$VERSION = '${PVR}':" \
		-e "/^@docs/s:doc/COPYING ::" \
		Makefile.PL || die
}

src_configure() {
	# Must match the order of elements in @opt_components in Makefile.PL
	make_config() {
		# Never accept default configuration
		echo "no"

		# Enable Agentina
		usex ar
		# Enable Switzerland Search
		usex ch-search
		# Enable EU epgdata.com including fanart
		usex eu-epgdata
		# Enable Europe (xmltv.se / xmltvse)
		usex eu-xmltvse
		# Enable Finland
		usex fi
		# Enable Swedish listings in Finland
		usex fi-sv
		# Enable France
		usex fr
		# Enable Hungary Romania Slovakia Czechia
		usex huro
		# Enable Iceland
		usex is
		# Enable Italy
		usex it
		# Enable Italy from DVB-S stream
		usex it-dvb
		# Enable North America - schedulesdirect.org
		usex na-dd
		# Enable North America (DirecTV)
		usex na-dtv
		# Enable North America  (TVMedia)
		usex na-tvmedia
		# Enable Portugal (Vodafone)
		usex pt-vodafone
		# Enable Turkey (Digiturk)
		usex tr
		# Enable UK/Ireland - TV Guide Website
		usex uk-tvguide
		# Enable Schedules Direct JSON
		usex zz-sdjson
		# Enable Schedules Direct JSON (SQLite version)
		usex zz-sdjson-sqlite
		# rules to improve episode numbering
		usex tv-check
		# Enable combiner
		usex tv-combiner
		# Enable CGI program to filter listings (to install manually)
		usex tv-pick-cgi
	}

	pm_echovar=`make_config`
	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	if use tv-pick-cgi; then
		dobin choose/tv_pick/tv_pick_cgi
	fi
}

pkg_postinst() {
	if use tv-pick-cgi; then
		elog "To use tv_pick_cgi, please link it from /usr/bin/tv_pick_cgi"
		elog "to where the ScriptAlias directive is configured."
	fi

	if use it-dvb; then
		elog "The perl module Linux::DVB must be manually installed."
		elog "A slightly out of date Linux::DVB is in CPAN, but not in portage."
	fi
}
