# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_TEST="do"
inherit perl-module

DESCRIPTION="A wiki compiler"
HOMEPAGE="http://ikiwiki.info/"
SRC_URI="mirror://debian/pool/main/i/ikiwiki/${PN}_${PV}.orig.tar.xz"
S="${WORKDIR}/ikiwiki-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="extras minimal test"
RESTRICT="!test? ( test )"

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
	|| (
		media-gfx/imagemagick[perl]
		media-gfx/graphicsmagick[perl]
	)
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

BDEPEND="test? ( ${TEST_DEPEND} )"

src_prepare() {
	default

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

	#dodoc -r doc/examples
	#docompress -x /usr/share/doc/${PF}/examples
	dodoc -r html/.
	dodoc CHANGELOG
	dodoc debian/NEWS
}
