# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-v${PV}"
DESCRIPTION="Command line based, SMTP email agent"
HOMEPAGE="http://caspian.dotconf.net/menu/Software/SendEmail/"
SRC_URI="http://caspian.dotconf.net/menu/Software/SendEmail/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="ssl"

RDEPEND="
	dev-lang/perl
	ssl? ( dev-perl/IO-Socket-SSL )
"

PATCHES=(
	"${FILESDIR}"/${PV}-overzealous-version-check.patch
	"${FILESDIR}"/${PV}-overzealous-verify-mode-check.patch
)

src_install() {
	dobin sendEmail
	dodoc CHANGELOG README TODO
}
