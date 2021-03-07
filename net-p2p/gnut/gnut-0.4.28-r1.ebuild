# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Text-mode gnutella client"
HOMEPAGE="http://www.gnutelliums.com/linux_unix/gnut/"
SRC_URI="
	http://alge.anart.no/ftp/pub/gnutella/${P}.tar.gz
	mirror://gentoo/${P}-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

PATCHES=(
	"${WORKDIR}"/configure.patch
	"${WORKDIR}"/src.patch
)

src_install() {
	local HTML_DOCS=( doc/*.html )
	default
	dodoc doc/TUTORIAL GDJ HACKING
}
