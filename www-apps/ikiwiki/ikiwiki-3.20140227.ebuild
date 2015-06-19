# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/ikiwiki/ikiwiki-3.20140227.ebuild,v 1.2 2015/06/13 17:20:27 dilfridge Exp $

EAPI=5

inherit perl-module

DESCRIPTION="A wiki compiler"
HOMEPAGE="http://ikiwiki.info/"
SRC_URI="mirror://debian/pool/main/i/ikiwiki/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="extras minimal test"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}

#Authen::Passphrase
#Search::Xapian
#Locale::gettext
#Crypt::SSLeay
#Text::CSV
#Text::Typography
#Text::Textile
#Text::WikiFormat
#Net::Amazon::S3

EXTRA_RDEPEND="
	dev-python/docutils
	dev-perl/Digest-SHA1
	dev-perl/File-MimeInfo
	dev-perl/RPC-XML
	dev-perl/XML-Feed
	dev-perl/LWPx-ParanoidAgent
	dev-perl/Net-OpenID-Consumer
"

SUGGESTED_RDEPEND="
	dev-perl/CGI
	>=dev-perl/CGI-FormBuilder-3.0202
	>=dev-perl/CGI-Session-4.14
	dev-perl/Mail-Sendmail
	dev-perl/Term-ReadLine-Gnu
	dev-perl/XML-Simple
	media-gfx/imagemagick[perl]
"

TEST_DEPEND="
	dev-perl/File-chdir
	dev-perl/File-ReadBackwards
	dev-perl/File-MimeInfo
	dev-perl/HTML-LinkExtractor
	dev-perl/HTML-Tree
	dev-perl/Net-OpenID-Consumer
	dev-perl/RPC-XML
	dev-perl/XML-Feed
	dev-perl/XML-Twig
	dev-vcs/cvs[server]
	dev-vcs/cvsps"

DEPEND="
	>=dev-lang/perl-5.10
	app-text/po4a
	dev-perl/HTML-Parser
	dev-perl/HTML-Scrubber
	dev-perl/HTML-Template
	dev-perl/URI
	dev-perl/Text-Markdown
	dev-perl/TimeDate
	dev-perl/YAML-LibYAML
"

RDEPEND="${DEPEND}
	!minimal? (
		${SUGGESTED_RDEPEND}
		extras? (
			${EXTRA_RDEPEND}
		)
	)
"

DEPEND="${DEPEND}
	test? ( ${TEST_DEPEND} )"

SRC_TEST=do

src_prepare() {
	#bug 498444 /usr/lib/plan9/lib/fortunes.index
	addpredict "/usr/lib/plan9/lib/fortunes"

	sed -i 's,lib/ikiwiki,libexec/ikiwiki,' \
		"${S}"/{IkiWiki.pm,Makefile.PL,doc/plugins/install.mdwn} || die
#	if use w3m ; then
		sed -i 's,lib/w3m,libexec/w3m,' "${S}"/Makefile.PL || die
#	else
#		sed -i '/w3m/d' "${S}"/Makefile.PL || die
#	fi
}

src_install() {
	emake DESTDIR="${D}" pure_install
	insinto /etc/ikiwiki
	doins wikilist

	#insinto /usr/share/doc/${PF}/examples
	#doins -r doc/examples/*
	dohtml -r -A setup html/*
	dodoc debian/{NEWS,changelog}
}
