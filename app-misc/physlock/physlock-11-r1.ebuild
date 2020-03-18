# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="lightweight Linux console locking tool"
HOMEPAGE="https://github.com/muennich/physlock"
SRC_URI="https://github.com/muennich/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dosym login /etc/pam.d/${PN}
}
