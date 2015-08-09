# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="A small utility for creating backups on DV tapes"
HOMEPAGE="http://dvbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/dvbackup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-libs/glibc
	dev-libs/popt
	sys-libs/zlib"

RDEPEND="${DEPEND}
	media-libs/libdv"

src_prepare() {
	local i

	epatch "${FILESDIR}/${P}-gcc4.diff"

	# fix Makefile to respect $LDFLAGS
	sed -i -e 's:gcc \$(CFLAGS):\$(CC) \$(CFLAGS) \$(LDFLAGS):g' \
		-e 's:^\(CFLAGS=\):#\1:g' Makefile

	# convert LATIN1 docs to UTF-8
	for i in ChangeLog ReleaseNotes; do
		if [ -f "${i}" ]; then
			echo ">>> Converting ${i} to UTF-8"
			iconv -f LATIN1 -t UTF8 -o "${i}~" "${i}" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		fi
	done
}

src_compile() {
	emake dvbackup || die "emake failed"
}

src_install() {
	dobin dvbackup
	insinto /usr/share/${PN}
	doins underrun-ntsc.dv underrun-pal.dv
	dodoc AUTHORS ChangeLog ReleaseNotes
	dohtml dvbackup.html
}
