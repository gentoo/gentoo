# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Validation tool for tinydns-data zone files"
SRC_URI="https://x42.com/software/valtz/${PN}.tgz -> ${P}.tgz"
HOMEPAGE="https://x42.com/software/valtz/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"

PATCHES=( "${FILESDIR}/fix-generic-records-support.patch"
		  "${FILESDIR}/allow-underscores-in-records.patch"
		  "${FILESDIR}/add-support-for-srv-records.patch" )

src_install() {
	dobin valtz
	dodoc README CHANGES
}
