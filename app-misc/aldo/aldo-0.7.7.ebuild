# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/aldo/aldo-0.7.7.ebuild,v 1.3 2014/01/17 17:52:00 creffett Exp $

EAPI=5

DESCRIPTION="A morse tutor"
HOMEPAGE="http://www.nongnu.org/aldo"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=media-libs/libao-0.8.5"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}
