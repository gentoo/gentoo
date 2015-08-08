# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils sgml-catalog toolchain-funcs

DESCRIPTION="A toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="http://packages.qa.debian.org/l/linuxdoc-tools.html"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.tar.gz"

LICENSE="MIT SGMLUG"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~x86-fbsd"

DEPEND="app-text/openjade
	app-text/opensp
	app-text/sgml-common
	dev-texlive/texlive-fontsrecommended
	dev-lang/perl
	sys-apps/gawk
	sys-apps/groff
	virtual/latex-base"

RDEPEND="${DEPEND}"

sgml-catalog_cat_include "/etc/sgml/linuxdoc.cat" \
	"/usr/share/linuxdoc-tools/linuxdoc-tools.catalog"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-letter.patch" \
		"${FILESDIR}/${PN}-0.9.21-malloc.patch" \
		"${FILESDIR}/${P}-compiler.patch" \
		"${FILESDIR}/${P}-lex.patch"

	# Wrong path for the catalog.
	sed -i -e \
		's,/iso-entities-8879.1986/iso-entities.cat,/sgml-iso-entities-8879.1986/catalog,' \
		perl5lib/LinuxDocTools.pm || die 'sed failed'

	# Fix incorrect version string in upstream tarball
	sed -i -e "s/0.9.66/${PV}/" VERSION || die 'sed on VERSION failed'

	epatch_user
}

src_configure() {
	tc-export CC
	econf --with-installed-iso-entities
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	# Else fails with sandbox violations
	export VARTEXFONTS="${T}/fonts"

	# Besides the path being wrong, in changing perl5libdir, it cannot find the
	# catalog.
	export SGML_CATALOG_FILES="/usr/share/sgml/sgml-iso-entities-8879.1986/catalog"

	eval `perl -V:installvendorarch`
	emake \
		DESTDIR="${D}" \
		perl5libdir="${installvendorarch}" \
		LINUXDOCDOC="/usr/share/doc/${PF}/guide" \
		install

	insinto /usr/share/texmf/tex/latex/misc
	doins tex/*.sty

	dodoc ChangeLog README
}
