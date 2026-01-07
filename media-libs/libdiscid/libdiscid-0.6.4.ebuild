# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Client library to create MusicBrainz enabled tagging applications"
HOMEPAGE="http://musicbrainz.org/doc/libdiscid"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	dodoc examples/discid.c

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
