# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/chasen/chasen-2.4.4-r3.ebuild,v 1.2 2014/11/13 20:54:56 axs Exp $

EAPI="5"
inherit perl-module

DESCRIPTION="Japanese Morphological Analysis System, ChaSen"
HOMEPAGE="http://chasen-legacy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp//chasen-legacy/32224/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~sparc-solaris"
IUSE="perl static-libs"

DEPEND=">=dev-libs/darts-0.32"
RDEPEND="${DEPEND}
	perl? ( !dev-perl/Text-ChaSen )"
PDEPEND=">=app-dicts/ipadic-2.7.0"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cve-2011-4000.patch
}

src_configure() {
	econf $(use_enable static-libs static)
	if use perl ; then
		cd "${S}"/perl
		perl-module_src_configure
	fi
}

src_compile() {
	emake || die
	if use perl ; then
		cd "${S}"/perl
		perl-module_src_compile
	fi
}

src_test() {
	emake check || die
	if use perl ; then
		cd "${S}"/perl
		perl-module_src_test
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README

	if use perl ; then
		cd "${S}"/perl
		perl-module_src_install
		newdoc README README.perl
	fi

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete
	fi
}
