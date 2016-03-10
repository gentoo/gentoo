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
KEYWORDS="amd64 ppc x86 ~x86-linux"

IUSE="ar ch dtvla uk_rt uk_bleb is it na_dd na_icons fi es_laguiatv es_miguiatv ee re huro dk se_swedb hr no_gf fr pt eu_epg tv_combiner tv_pick_cgi tv_check na_dtv
za nl in il"

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
	nl? ( dev-perl/HTML-Tree )
	na_icons? ( dev-perl/HTML-TableExtract >=dev-perl/WWW-Mechanize-1.02 )
	dk? ( dev-perl/HTML-Tree dev-perl/DateTime dev-perl/Parse-RecDescent )
	fi? ( dev-perl/HTML-Tree )
	fr? ( >=dev-perl/HTML-Parser-3.34 dev-perl/HTML-Tree )
	huro? ( dev-perl/HTML-Tree )
	it? ( dev-perl/XML-Simple )
	is? ( dev-perl/XML-LibXSLT )
	na_dd? ( dev-perl/SOAP-Lite dev-perl/TermReadKey )
	no_gf? ( dev-perl/HTTP-Cache-Transparent dev-perl/IO-stringy dev-perl/XML-LibXML )
	pt? ( dev-perl/HTML-Tree dev-perl/Unicode-UTF8simple )
	eu_epg? ( dev-perl/Archive-Zip )
	se_swedb? ( dev-perl/HTTP-Cache-Transparent dev-perl/IO-stringy dev-perl/XML-LibXML )
	hr? ( dev-perl/HTTP-Cache-Transparent dev-perl/IO-stringy dev-perl/XML-LibXML )
	uk_rt? ( dev-perl/HTTP-Cache-Transparent dev-perl/IO-stringy )
	uk_bleb? ( dev-perl/Archive-Zip dev-perl/IO-stringy )
	ee? ( dev-perl/IO-stringy )
	re? ( dev-perl/Lingua-EN-Numbers-Ordinate )
	tv_combiner? ( dev-perl/XML-LibXML )
	tv_check? ( dev-perl/perl-tk dev-perl/Tk-TableMatrix )
	tv_pick_cgi? ( dev-perl/CGI dev-perl/Lingua-EN-Numbers-Ordinate )
	na_dtv? ( >=dev-perl/WWW-Mechanize-1.02 dev-perl/TimeDate dev-perl/IO-stringy dev-perl/XML-LibXML )
	"

REQUIRED_USE="na_icons? ( na_dd )"

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
		usex ch
		# Enable Latin America
		usex dtvla
		# Enable Alternate Brittain
		usex uk_rt
		# Enable Alternate Brittain 2
		usex uk_bleb
		# Enable Belgium and Luxemburg
		#use be && echo "yes" || echo "no"
		#Enable Iceland
		usex is
		# Enable Italy
		usex it
		# Enable Italy from DVB-S stream
		echo "no" # missing Linux::DVB
		# Enable India (experimental)
		usex in
		# Enable North America using DataDirect
		usex na_dd
		# Enable North America channel icons
		usex na_icons
		# Enable Finland
		usex fi
		# Enable Israel
		usex il
		# Enable Spain
		#use es  && echo "yes" || echo "no"
		# Enable Spain Digital
		# use es_digital && echo "yes" || echo "no"
		# Israel Temporary Disabled
		# use il && echo "yes" || echo "no"
		#echo "no"
		# Enable Spain Alternatives
		usex es_laguiatv
		usex es_miguiatv
		# Enable Netherlands
		usex nl
		# Enable Alternate Netherlands
		#use nl_wolf  && echo "yes" || echo "no"
		# Enable Hungary and Romania
		usex huro
		# Enable Denmark
		usex dk
		# Enable Japan
		#use jp  && echo "yes" || echo "no"
		# Enable Sweden
		usex se_swedb
		# Enable Croatia
		usex hr
		# Enable Norway Gfeed
		usex no_gf
		# Enable France
		usex fr
		# Enable Norway
		#use no  && echo "yes" || echo "no"
		# Enable Portugal
		usex pt
		# Enable South Africa
		usex za
		# Enable Europe epg
		usex eu_epg
		# Enable combiner
		usex tv_combiner
		# Enable GUI checking.
		usex tv_check
		# Enable CGI support
		usex tv_pick_cgi
		# Enable Estonia
		usex ee
		# Enable Reunion Island
		usex re
		# Enable Caledonie Island
		#use nc && echo "yes" || echo "no"
		# Enable North America DirecTV
		usex na_dtv
	}

	pm_echovar=`make_config`
	perl-module_src_configure
}

src_install() {
	# actually make test should be unneede, but if non na grabbers
	# start to not install remove comment below
	#make test
	#make

	# to bypass build issue
	#make DESTDIR=${D} install || die "error installing"

	perl-module_src_install

	for i in `grep -rl "${D}" "${D}"` ; do
		sed -e "s:${D}::g" -i "${i}"
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
