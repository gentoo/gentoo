# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils perl-module sgml-catalog toolchain-funcs

DESCRIPTION="A toolset for processing LinuxDoc DTD SGML files"
HOMEPAGE="https://tracker.debian.org/pkg/linuxdoc-tools"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="MIT SGMLUG"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~x86-fbsd"
IUSE="doc"

DEPEND="
	|| ( app-text/openjade app-text/opensp )
	app-text/sgml-common
	dev-lang/perl:=
	|| ( sys-apps/gawk sys-apps/mawk )
	sys-apps/groff
	doc? (
		dev-texlive/texlive-fontsrecommended
		virtual/latex-base
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-compiler.patch" )

DOCS=( ChangeLog README )

sgml-catalog_cat_include "/etc/sgml/linuxdoc.cat" \
	"/usr/share/linuxdoc-tools/linuxdoc-tools.catalog"

src_prepare() {
	# Fix malloc include.
	sed -e \
		's/#include <malloc.h>/#include <stdlib.h>/' \
		-i rtf-fix/rtf2rtf.l || die

	# Fix SGML catalog path.
	sed -e \
		's%/iso-entities-8879.1986/iso-entities.cat%/sgml-iso-entities-8879.1986/catalog%' \
		-i perl5lib/LinuxDocTools.pm || die

	# Fix doc install path.
	sed -e \
		"s%/share/doc/linuxdoc-tools%/share/doc/${PF}%" \
		-i Makefile.in

	# Upstream developers unconditionally build docs during the install phase.
	# The only sane solution in this case is to patch things out from Makefile.
	# See Gentoo bug #558610 for more info.
	use doc || epatch "${FILESDIR}/${P}-disable-doc-build.patch"

	autotools-utils_src_prepare
}

src_configure() {
	perl_set_version
	tc-export CC
	local myeconfargs=(
		--with-texdir="/usr/share/texmf/tex/latex/misc"
		--with-perllibdir="${VENDOR_ARCH}"
		--with-installed-iso-entities
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	# Prevent access violations from bitmap font files generation.
	export VARTEXFONTS="${T}/fonts"

	# Help linuxdoc-tools find sgml-iso-entities catalog again.
	export SGML_CATALOG_FILES="/usr/share/sgml/sgml-iso-entities-8879.1986/catalog"

	autotools-utils_src_install
}
