# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Routines to generate / analyze graphs using models for internetwork topology"
HOMEPAGE="http://www.cc.gatech.edu/fac/Ellen.Zegura/graphs.html
		  http://www.isi.edu/nsnam/ns/ns-topogen.html#gt-itm"
SRC_URI="http://www.cc.gatech.edu/fac/Ellen.Zegura/gt-itm/gt-itm.tar.gz
		 http://www.isi.edu/nsnam/dist/sgb2ns.tar.gz"

LICENSE="all-rights-reserved sgb2ns"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"
IUSE="doc"

DEPEND="dev-util/sgb"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
S2="${WORKDIR}/sgb2ns"

PATCHES=( "${FILESDIR}"/${PN}-implicits.patch )
DOCS=( README docs/. )

src_unpack() {
	unpack sgb2ns.tar.gz

	mkdir "$S" || die
	cd "$S" || die
	unpack gt-itm.tar.gz
}
src_prepare() {
	sed -ri -e '/^[[:alnum:]]+\.o:/d' \
		-e 's|LIBS = -lm -lgb.*|LIBS = -lm -lgb|' \
		-e 's/\$\(CC\)/& \$\(LDFLAGS\)/g' \
		src/Makefile || die
	sed -ri -e '/^SYS = -DSYSV/d' \
		-e 's|LIBS = -lm -lgb.*|LIBS = -lm -lgb|' \
		-e 's/\$\(CC\)/& \$\(LDFLAGS\)/g' \
		"${S2}"/Makefile  || die

	rm -f lib/* || die

	while IFS="" read -d $'\0' -r file; do
		sed -i -re 's|(\.\./)+bin/||g' "$file" || die
	done < <(find sample-graphs/ -perm /a+x -type f -name 'Run*' -print0)

	sed -i -e 's|sys/types.h|sys/param.h|' src/geog.c || die
	sed -i -e '162 s/connected $/connected \\/' src/eval.c || die

	# fix implicit function declarations
	sed -i -e '/stdio.h/ a\#include <stdlib.h>' \
		"${S2}/sgb2comns.c" "${S2}/sgb2hierns.c" || die
	sed -i -e "s/<strings.h>/<string.h>/g" "${S2}/sgb2hierns.c" || die
	default
}

src_compile() {
	emake -C src CFLAGS="${CFLAGS} -I../include" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"

	emake -C "${S2}" CFLAGS="${CFLAGS} -I\$(IDIR) -L\$(LDIR)" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin bin/*
	einstalldocs
	newdoc "${S2}"/README README.sgb2ns
	if use doc; then
		dodoc -r sample-graphs
		dodoc "${S2}"/*.{tcl,gb}
		docompress -x "/usr/share/doc/${PF}/sample-graphs"
	fi
}
