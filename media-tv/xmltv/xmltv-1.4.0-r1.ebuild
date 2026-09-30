# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Set of utilities to manage TV listings stored in the XMLTV format"
HOMEPAGE="http://wiki.xmltv.org/index.php/XMLTVProject https://github.com/XMLTV/xmltv"
SRC_URI="https://github.com/XMLTV/xmltv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

IUSE="ar ch-search fi huro is it-dvb"
IUSE+=" na-dd na-tvmedia pt-vodafone tv-check tv-combiner"
IUSE+=" tv-pick-cgi uk-freeview zz-sdjson zz-sdjson-sqlite"

# Check both %prereqs and %recommended in Makefile.PL
RDEPEND="
	>=dev-perl/Date-Manip-5.420.0
	dev-perl/File-Slurp
	dev-perl/JSON
	dev-perl/HTTP-Message
	>=dev-perl/libwww-perl-5.650.0
	>=dev-perl/Lingua-Preferred-0.2.4
	dev-perl/LWP-Online
	dev-perl/LWP-Protocol-https
	dev-perl/PerlIO-gzip
	>=dev-perl/Term-ProgressBar-2.30.0
	dev-perl/TermReadKey
	dev-perl/URI
	dev-perl/XML-LibXML
	>=dev-perl/XML-Parser-2.340.0
	dev-perl/XML-TreePP
	>=dev-perl/XML-Twig-3.280.0
	>=dev-perl/XML-Writer-0.600.0
	dev-perl/Unicode-String
	ar? (
		dev-perl/DateTime
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
		dev-perl/HTTP-Cookies
	)
	ch-search? (
		dev-perl/HTML-Tree
		>=dev-perl/HTML-Parser-1.270.0
		dev-perl/HTTP-Cookies
	)
	fi? (
		dev-perl/HTML-Tree
	)
	huro? (
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
	)
	is? (
		dev-perl/HTML-Parser
		dev-perl/HTML-Tree
		dev-perl/XML-DOM
		dev-perl/XML-LibXSLT
	)
	it-dvb? (
		dev-perl/Data-Dump
		dev-perl/HTML-Parser
		dev-perl/Linux-DVB
	)
	na-dd? (
		dev-perl/HTTP-Daemon
		dev-perl/SOAP-Lite
	)
	pt-vodafone? (
		dev-perl/DateTime
		dev-perl/DateTime-Format-Strptime
		dev-perl/Text-Unidecode
		dev-perl/URI-Encode
	)
	uk-freeview? (
		dev-perl/DateTime
		dev-perl/JSON
	)
	zz-sdjson? (
		dev-perl/DateTime
		dev-perl/Try-Tiny
	)
	zz-sdjson-sqlite? (
		dev-perl/DateTime
		dev-perl/DateTime-Format-ISO8601
		dev-perl/DateTime-Format-SQLite
		dev-perl/DateTime-TimeZone
		dev-perl/DBD-SQLite
		dev-perl/DBI
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
	# Must match the order of elements in @opt_components in Makefile.PL!
	#
	# It changes regularly on updates. If a new component is omitted,
	# it must be replaced with "no", not just ignored.
	make_config() {
		# Never accept default configuration
		echo "no"

		# Enable Switzerland Search
		usex ch-search
		# Enable Finland
		usex fi
		# Enable Swedish listings in Finland
		#usex fi-sv
		# Enable France
		#usex fr
		# Enable Hungary Romania Slovakia Czechia
		usex huro
		# Enable Israel
		#usex il
		# Enable Iceland
		usex is
		# Enable Italy
		#usex it
		# Enable Italy from DVB-S stream
		usex it-dvb
		# Enable North America - schedulesdirect.org
		usex na-dd
		# Enable North America (DirecTV)
		#usex na-dtv
		# Enable North America (TVMedia)
		usex na-tvmedia
		# Enable Portugal (MEO)
		#usex pt-meo
		# Enable Portugal (Vodafone)
		usex pt-vodafone
		# Enable UK (Freeview)
		usex uk-freeview
		# Enable UK/Ireland - TV Guide Website
		#usex uk-tvguide
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

	pm_echovar=$(make_config)
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
		elog "To use tv_pick_cgi, please link it from ${EPREFIX}/usr/bin/tv_pick_cgi"
		elog "to where the ScriptAlias directive is configured."
	fi
}
