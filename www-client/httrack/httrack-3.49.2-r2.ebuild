# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils xdg-utils

DESCRIPTION="HTTrack Website Copier, Open Source Offline Browser"
HOMEPAGE="https://www.httrack.com/"
SRC_URI="https://mirror.httrack.com/historical/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="libressl static-libs"

RDEPEND=">=sys-libs/zlib-1.2.5.1-r1
	!libressl? ( >=dev-libs/openssl-1.1.0:= )
	libressl? ( dev-libs/libressl )
	"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README greetings.txt history.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-3.48.13-minizip.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	# Make webhttrack work despite FEATURES=nodoc cutting
	# all of /usr/share/doc/ away (bug #493376)
	if has nodoc ${FEATURES} ; then
		dodir /usr/share/${PF}/
		mv "${D}"/usr/share/{doc/,}${PF}/html || die

		rm "${D}"/usr/share/${PN}/html || die
		dosym ../../${PF}/html /usr/share/${PN}/html
	fi

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
