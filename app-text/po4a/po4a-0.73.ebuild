# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PLOCALES="ace af ar ca cs da de eo es et eu fr hr hu id it ja ka kn ko nb nl pl pt pt_BR ru sl sr sr_Cyrl sv uk vi zh_Hans zh_Hant"

inherit perl-module plocale

DESCRIPTION="Tools to ease the translation of documentation"
HOMEPAGE="https://po4a.org/"
SRC_URI="https://github.com/mquinson/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/opensp
	dev-libs/libxslt
	dev-perl/Locale-gettext
	dev-perl/Pod-Parser
	dev-perl/SGMLSpm
	dev-perl/Syntax-Keyword-Try
	dev-perl/TermReadKey
	dev-perl/Text-WrapI18N
	dev-perl/Unicode-LineBreak
	dev-perl/YAML-Tiny
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-perl/Module-Build
	sys-devel/gettext
	test? (
		app-text/docbook-sgml-dtd:4.1
		dev-perl/Test-Pod
		virtual/latex-base
	)"

PATCHES=( "${FILESDIR}"/${PN}-man.patch )

DIST_TEST="do"

src_prepare() {
	plocale_find_changes "${S}/po/bin" '' '.po'

	rm_locale() {
		PERL_RM_FILES+=( po/{bin,pod}/${1}.po )
	}
	plocale_for_each_disabled_locale rm_locale

	perl-module_src_prepare
}
