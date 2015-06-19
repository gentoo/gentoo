# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/xcin/xcin-2.5.3_pre3-r3.ebuild,v 1.1 2011/11/20 23:40:31 matsuu Exp $

EAPI="4"
inherit multilib eutils autotools libtool

MY_P=${PN}_2.5.2.99.pre2+cvs20030224

DESCRIPTION="Chinese X Input Method"
HOMEPAGE="http://cle.linux.org.tw/xcin/"
SRC_URI="mirror://debian/pool/main/x/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${MY_P}-1.4.diff.gz"

LICENSE="XCIN GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug nls unicode"

RDEPEND=">=sys-libs/db-4.5
	>=app-i18n/libtabe-0.2.6
	unicode? ( media-fonts/hkscs-ming
		media-fonts/arphicfonts )
	dev-libs/libchewing
	x11-libs/libX11"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P/_/-}"

src_prepare() {
	epatch \
		"${WORKDIR}"/${MY_P}-1.4.diff \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-make.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	rm -f configure
	cd script
	elibtoolize
	eautoreconf
	mv configure ../
}

src_configure() {
	econf \
		--disable-static \
		--with-xcin-rcdir="${EPREFIX}/etc" \
		--with-xcin-dir="${EPREFIX}/usr/$(get_libdir)/xcin25" \
		--with-db-lib="${EPREFIX}/usr/$(get_libdir)" \
		--with-tabe-inc="${EPREFIX}/usr/include/tabe" \
		--with-tabe-lib="${EPREFIX}/usr/$(get_libdir)" \
		$(use_enable debug)
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		program_prefix="${D}" \
		install || die

	find "${ED}" -name "*.la" -type f -delete || die

	for docdir in doc doc/En doc/En/internal doc/history doc/internal doc/modules; do
		docinto ${docdir#doc/}
		for doc in $(find ${docdir} -maxdepth '1' -type 'f'); do
			if use unicode; then
					iconv -f BIG5 -t UTF-8 --output=${doc}.UTF-8 ${doc}
					mv ${doc}.UTF-8 ${doc}
			fi
			dodoc ${doc}
		done
	done
}
