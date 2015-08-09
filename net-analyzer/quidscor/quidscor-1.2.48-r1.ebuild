# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Qualys IDS Correlation Daemon"
HOMEPAGE="http://quidscor.sourceforge.net/"
SRC_URI="mirror://sourceforge/quidscor/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"

DEPEND="
	>=dev-libs/libxml2-2.4
	>=net-misc/curl-7.10
	>=net-analyzer/snort-2.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-curl-types.h.patch \
		"${FILESDIR}"/${P}-paths.patch \
		"${FILESDIR}"/${P}-strip.patch

	#yes, the fix below is as pathetic as it seems
	echo "#define FALSE 0" >> libqg/libqg.h || die
	echo "#define TRUE 1" >> libqg/libqg.h || die
}

src_compile() {
	emake EXTRA_CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX=/usr STAGING_PREFIX="${D}" install
	dodoc ChangeLog FAQ MANIFEST README TODO
	# fix ugly install
	cd "${D}"/usr || die
	mv etc .. || die
	rm -r doc || die
}
