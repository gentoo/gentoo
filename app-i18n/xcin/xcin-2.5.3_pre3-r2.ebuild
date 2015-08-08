# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib eutils autotools libtool

MY_P=${PN}_2.5.2.99.pre2+cvs20030224

DESCRIPTION="Chinese X Input Method"
HOMEPAGE="http://cle.linux.org.tw/xcin/"
SRC_URI="mirror://debian/pool/main/x/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${MY_P}-1.4.diff.gz"

LICENSE="XCIN GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="debug nls unicode"

RDEPEND=">=sys-libs/db-4.5
	>=app-i18n/libtabe-0.2.6
	unicode? ( media-fonts/hkscs-ming
		media-fonts/arphicfonts )
	dev-libs/libchewing
	x11-libs/libX11"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P/_/-}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${MY_P}-1.4.diff
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	rm -f configure
	cd script
	elibtoolize
	eautoreconf
	mv configure ../
	cd ..
}

src_compile() {
	myconf="--with-xcin-rcdir=/etc
		--with-xcin-dir=/usr/$(get_libdir)/xcin25
		--with-db-lib=/usr/$(get_libdir)
		--with-tabe-inc=/usr/include/tabe
		--with-tabe-lib=/usr/$(get_libdir)
		$(use_enable debug)"

	econf ${myconf}
	emake -j1 || die "emake failed."
}

src_install() {
	emake \
		prefix="${D}/usr" \
		program_prefix="${D}" \
		install || die

	for docdir in doc doc/En doc/En/internal doc/history doc/internal doc/modules; do
		docinto ${docdir#doc/}
		if use unicode; then
			for doc in $(find ${docdir} -maxdepth '1' -type 'f'); do
				iconv -f BIG5 -t UTF-8 --output=${doc}.UTF-8 ${doc}
				mv ${doc}.UTF-8 ${doc}
			done
		fi
		dodoc ${docdir}/*
	done
}
