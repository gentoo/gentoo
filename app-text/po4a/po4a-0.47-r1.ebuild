# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af ca cs da de eo es et eu fr hr id it ja kn ko nb nl pl pt_BR pt ru sl sv uk vi zh_CN zh_HK"
PLOCALES_BACKUP="en"

inherit perl-module l10n

DESCRIPTION="Tools for helping translation of documentation"
HOMEPAGE="https://po4a.org/"
SRC_URI="mirror://debian/pool/main/p/po4a/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/openjade
	dev-libs/libxslt
	dev-perl/Locale-gettext
	dev-perl/SGMLSpm
	dev-perl/TermReadKey
	dev-perl/Text-WrapI18N
	sys-devel/gettext"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-perl/Module-Build
	test? (
		app-text/docbook-sgml-dtd:4.1
		virtual/tex-base
	)"

# Running tests in parallel fails
DIST_TEST="do"

PATCHES=(
	# Fix bad escaping of '.' in @INC modification
	"${FILESDIR}"/${PN}-0.45-614122-no-dot-inc.patch
	"${FILESDIR}"/${PN}-man.patch
)

src_prepare() {
	# Check against locale files in ${S}/pod/bin for mismatches
	# with languages listed in PLOCALES
	local locales_path="${S}/po/bin"
	l10n_find_plocales_changes "${locales_path}" "" ".po"

	# Get rid of disabled locales
	my_get_disabled_locales() {
		PERL_RM_FILES=( "${PERL_RM_FILES[@]}" "po/bin/${1}.po" "po/pod/${1}.po" )
	}

	l10n_for_each_disabled_locale_do my_get_disabled_locales

	einfo "Your LINGUAS lists the following languages: ${LINGUAS}"

	perl-module_src_prepare
}
