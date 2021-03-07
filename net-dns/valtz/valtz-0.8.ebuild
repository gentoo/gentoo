# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Validation tool for tinydns-data zone files"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"
HOMEPAGE="http://michael.orlitzky.com/code/valtz.xhtml"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl"

src_install() {
	dobin valtz
	doman valtz.1
	dodoc AUTHORS README CHANGES
}
