# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Validation tool for tinydns-data zone files"
HOMEPAGE="https://michael.orlitzky.com/code/valtz.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

src_install() {
	dobin valtz
	doman valtz.1
	dodoc AUTHORS README CHANGES
}
