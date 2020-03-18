# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="kernel.org uploader tool"
HOMEPAGE="https://www.kernel.org/pub/software/network/kup"
SRC_URI="https://www.kernel.org/pub/software/network/kup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/BSD-Resource
	dev-perl/Config-Simple
"

DOCS=( README )

src_install() {
	dobin "${PN}" "${PN}-server" gpg-sign-all
	doman "${PN}.1"
	einstalldocs
}
