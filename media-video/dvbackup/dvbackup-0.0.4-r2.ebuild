# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A small utility for creating backups on DV tapes"
HOMEPAGE="http://dvbackup.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/dvbackup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="sys-libs/glibc
	dev-libs/popt
	sys-libs/zlib"

RDEPEND="${DEPEND}
	media-libs/libdv"

src_prepare() {
	default

	local i

	eapply "${FILESDIR}/${P}-gcc4.diff"

	# fix Makefile to respect $LDFLAGS
	sed -i -e 's:gcc \$(CFLAGS):\$(CC) \$(CFLAGS) \$(LDFLAGS):g' \
		-e 's:^\(CFLAGS=\):#\1:g' Makefile || die "sed failed"

	# convert LATIN1 docs to UTF-8
	for i in ChangeLog ReleaseNotes; do
		if [ -f "${i}" ]; then
			echo ">>> Converting ${i} to UTF-8"
			iconv -f LATIN1 -t UTF8 -o "${i}~" "${i}" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		fi
	done
}

src_compile() {
	emake CC="$(tc-getCC)" dvbackup
}

src_install() {
	dobin dvbackup
	insinto /usr/share/${PN}
	doins underrun-ntsc.dv underrun-pal.dv
	dodoc AUTHORS dvbackup.html ChangeLog ReleaseNotes
}
