# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit base mono

DESCRIPTION="Reminder Plugin for Tomboy"
HOMEPAGE="http://flukkost.nu/blog/tomboy-reminder/"
SRC_URI="http://flukkost.nu/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2.0
	 >=app-misc/tomboy-0.12"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.9-unicode-regex.patch"
)

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS ChangeLog AUTHORS || die "dodoc failed"
}
