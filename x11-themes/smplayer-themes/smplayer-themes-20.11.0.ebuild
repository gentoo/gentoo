# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Icon themes for smplayer"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="https://downloads.sourceforge.net/smplayer/${P}.tar.bz2"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 CC0-1.0 GPL-2 GPL-3+ LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86"

DEPEND="dev-qt/qtbase:6"
RDEPEND="media-video/smplayer"
BDEPEND="media-libs/libpng:0"

src_prepare() {
	default

	# bug 544108
	sed -i -e "s|rcc -binary|$(qt6_get_bindir)/../libexec/&|" themes/Makefile || die

	# bug 544160
	sed -i -e 's/make/$(MAKE)/' Makefile || die

	while read -d '' -r png ; do
		pngfix -q --out=${png/.png/fixed.png} ${png} # see pngfix help for exit codes
		[[ $? -gt 15 ]] && die "Failed to fix ${png}"
		mv -f ${png/.png/fixed.png} ${png} || die
	done < <(find . -type f -iname "*.png" -print0 || die)
}

src_install() {
	rm themes/Makefile || die
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
