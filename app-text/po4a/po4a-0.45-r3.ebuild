# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLOCALES="af ca cs da de eo es et eu fr hr id it ja kn ko nb nl pl pt_BR pt ru sl sv uk vi zh_CN zh_HK"
PLOCALES_BACKUP="en"

# Needed because this package also installs to vendor_perl
GENTOO_DEPEND_ON_PERL_SUBSLOT="yes"
inherit perl-app perl-module l10n

DESCRIPTION="Tools for helping translation of documentation"
HOMEPAGE="http://po4a.alioth.debian.org"
SRC_URI="mirror://debian/pool/main/p/po4a/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/SGMLSpm
	>=sys-devel/gettext-0.13
	app-text/openjade
	dev-libs/libxslt
	dev-perl/Locale-gettext
	dev-perl/TermReadKey
	dev-perl/Text-WrapI18N"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	test? ( app-text/docbook-sgml-dtd
		app-text/docbook-sgml-utils
		virtual/tex-base )"

SRC_TEST="do"

src_prepare() {
	# Check against locale files in ${S}/pod/bin for mismatches
	# with languages listed in PLOCALES
	local locales_path="$S/po/bin"
	l10n_find_plocales_changes "$locales_path" "" ".po"

	# Array containing locale files to remove
	local locales_to_remove=( )

	# Get rid of disabled locales
	my_get_disabled_locales() {
		locales_to_remove=( "${locales_to_remove[@]}" "po/bin/${1}.po" "po/pod/${1}.po" )
	}

	l10n_for_each_disabled_locale_do my_get_disabled_locales

	einfo "Your LINGUAS lists the following languages: $LINGUAS"
	einfo "Removing locale files not listed in it ..."

	# perl_rm_files also updates the Manifest file
	# and therefore silences Perl as to .po files we're about to clean
	perl_rm_files "${locales_to_remove[@]}"
}
