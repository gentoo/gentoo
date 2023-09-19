# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Icecast OGG streaming client, supports on the fly re-encoding"
HOMEPAGE="https://icecast.org/ices/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc64 sparc x86"

RDEPEND="
	acct-group/ices
	acct-user/ices
	dev-libs/libxml2
	media-libs/alsa-lib
	media-libs/libogg
	media-libs/libshout
	media-libs/libvorbis"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-libogg-test.patch
	"${FILESDIR}"/${P}-gettimeofday.patch
)

src_prepare() {
	default

	eautoreconf #740794,870973
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/etc/ices2
}

src_install() {
	default

	insinto /etc/ices2
	doins conf/*.xml

	docinto html
	dodoc doc/*.{html,css}

	newinitd "${FILESDIR}"/ices.initd-r1 ices

	keepdir /var/log/ices
	fperms 660 /var/log/ices
	fowners ices:ices /var/log/ices

	rm -r "${ED}"/usr/share/ices || die
}
