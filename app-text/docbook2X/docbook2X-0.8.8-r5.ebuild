# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools to convert docbook to man and info"
HOMEPAGE="https://docbook2x.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/docbook2x/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="test"

RESTRICT="!test? ( test )"

# dev-perl/XML-LibXML - although not mentioned upstream is required
# for make check to complete.
DEPEND="dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-NamespaceSupport
	dev-perl/XML-SAX
	dev-perl/XML-LibXML
	app-text/docbook-xsl-stylesheets
	=app-text/docbook-xml-dtd-4.2*"
RDEPEND="${DEPEND}"

PATCHES=(
	# Patches from debian, for description see patches itself.
	"${FILESDIR}/${P}-filename_whitespace_handling.patch"
	"${FILESDIR}/${P}-preprocessor_declaration_syntax.patch"
	"${FILESDIR}/${P}-error_on_missing_refentry.patch"
	# bug #296112
	"${FILESDIR}/${P}-drop-htmldir.patch"
	# https://sourceforge.net/p/docbook2x/bugs/25/
	"${FILESDIR}/${P}-stop-redeclaring-predefined-entity-lt.patch"
)

src_prepare() {
	default

	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die 'sed on configure.ac failed'

	# bug #290284
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-xslt-processor=libxslt
		--program-transform-name='/^docbook2/s,$,.pl,'
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dosym docbook2man.pl /usr/bin/docbook2x-man
	dosym docbook2texi.pl /usr/bin/docbook2x-texi
}
