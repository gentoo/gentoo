# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="cron script to sync portage and send update mails to root"
HOMEPAGE="https://github.com/gentoo/porticron"
SRC_URI="https://github.com/gentoo/porticron/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="
	app-portage/gentoolkit
"

src_install() {
	dosbin bin/porticron
	insinto /etc
	doins etc/porticron.conf
}
