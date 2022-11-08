# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Freedink game data"
HOMEPAGE="https://www.gnu.org/s/freedink/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="
	ZLIB
	CC-BY-3.0
	CC-BY-SA-3.0
	Free-Art-1.3
	GPL-2+
	GPL-3+
	OAL-1.0.1
	WTFPL-2
	public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	emake DESTDIR="${D}" DATADIR="${EPREFIX}"/usr/share install
	einstalldocs
}
