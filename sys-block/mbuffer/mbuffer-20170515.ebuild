# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="M(easuring)buffer is a replacement for buffer with additional functionality"
HOMEPAGE="http://www.maier-komor.de/mbuffer.html"
SRC_URI="http://www.maier-komor.de/software/mbuffer/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug ssl"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-20121111-resolv-multi-order-issue.patch"
	"${FILESDIR}/${PN}-20170515-sysconfdir.patch"
)

src_prepare() {
	ln -s "${DISTDIR}"/${P}.tgz test.tar #258881
	# work around "multi off" in /etc/host.conf and "::1 localhost"
	# *not* being the *first* "localhost" entry in /etc/hosts
	default
}

src_configure() {
	local myeconfargs=(
		$(use_enable ssl md5)
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}
