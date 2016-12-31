# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2"
SRC_URI="
	mirror://gnu-alpha/libidn/${P}.tar.gz
	https://ftp.iana.org/assignments/idna-tables-6.3.0/idna-tables-6.3.0.txt -> ${P}-idna-tables-6.3.0.txt
	http://www.unicode.org/Public/idna/6.3.0/IdnaMappingTable.txt -> ${P}-IdnaMappingTable.txt
	http://www.unicode.org/Public/6.3.0/ucd/DerivedNormalizationProps.txt -> ${P}-DerivedNormalizationProps.txt
	http://www.unicode.org/Public/idna/6.3.0/IdnaTest.txt -> ${P}-IdnaTest.txt
"

LICENSE="GPL-2+ LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86 ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	dev-libs/libunistring[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	sys-apps/help2man
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12-Werror.patch
	"${FILESDIR}"/${PN}-0.12-examples.patch
	"${FILESDIR}"/${PN}-0.12-gengetopt.patch
	"${FILESDIR}"/${PN}-0.12-noinstall.patch
	"${FILESDIR}"/${PN}-0.12-wget.patch
)

src_prepare() {
	default

	cp "${DISTDIR}"/${P}-idna-tables-6.3.0.txt "${S}"/idna-tables-6.3.0.txt || die
	cp "${DISTDIR}"/${P}-IdnaMappingTable.txt "${S}"/IdnaMappingTable.txt || die
	cp "${DISTDIR}"/${P}-DerivedNormalizationProps.txt "${S}"/DerivedNormalizationProps.txt || die
	cp "${DISTDIR}"/${P}-IdnaTest.txt "${S}"/tests/IdnaTest.txt || die

	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--without-included-libunistring
}

multilib_src_install() {
	default

	prune_libtool_files
}
