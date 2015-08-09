# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Routines to generate and analyze graphs using different models for internetwork topology"
HOMEPAGE="http://www.cc.gatech.edu/fac/Ellen.Zegura/graphs.html
		  http://www.isi.edu/nsnam/ns/ns-topogen.html#gt-itm"
SRC_URI="http://www.cc.gatech.edu/fac/Ellen.Zegura/gt-itm/gt-itm.tar.gz
		 http://www.isi.edu/nsnam/dist/sgb2ns.tar.gz"

LICENSE="all-rights-reserved sgb2ns"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror bindist"

DEPEND="dev-util/sgb"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
S2="${WORKDIR}/sgb2ns"

src_unpack() {
	unpack sgb2ns.tar.gz

	mkdir "${S}"
	cd "${S}"
	unpack gt-itm.tar.gz

	sed -r -e '/^[[:alnum:]]+\.o:/d' \
		-e 's|LIBS = -lm -lgb.*|LIBS = -lm -lgb|' \
		-e 's/\$\(CC\)/& \$\(LDFLAGS\)/g' \
		-i "${S}"/src/Makefile || die
	sed -r -e '/^SYS = -DSYSV/d' \
		-e 's|LIBS = -lm -lgb.*|LIBS = -lm -lgb|' \
		-e 's/\$\(CC\)/& \$\(LDFLAGS\)/g' \
		-i ${S2}/Makefile  || die

	rm -f "${S}"/lib/*

	find "${S}"/sample-graphs/ -perm +111 -type f -name 'Run*' \
	| xargs -r -n1 sed -re 's|(\.\./)+bin/||g' -i || die

	sed -e 's|sys/types.h|sys/param.h|' -i "${S}"/src/geog.c || die
	sed -e '162 s/connected $/connected \\/' -i "${S}"/src/eval.c || die

	# fix implicit function declarations
	sed -e '/stdio.h/ a\#include <stdlib.h>' \
		-i "${S2}/sgb2comns.c" "${S2}/sgb2hierns.c" || die
	sed -e "s/<strings.h>/<string.h>/g" \
		-i "${S2}/sgb2hierns.c" || die
	epatch "${FILESDIR}"/${PN}-implicits.patch
}

src_compile() {
	cd "${S}"/src
	emake CFLAGS="${CFLAGS} -I../include" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" || die

	cd "${S2}"
	emake CFLAGS="${CFLAGS} -I\$(IDIR) -L\$(LDIR)" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" || die
}

src_install() {
	dobin "${S}"/bin/* || die
	dodoc "${S}"/README "${S}"/docs/* || die
	cp -pPR "${S}"/sample-graphs "${D}"/usr/share/doc/${PF} || die

	cd "${S2}"
	dodoc *.tcl *.gb || die
	newdoc README README.sgb2ns || die

}
