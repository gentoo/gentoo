# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Facebook protocol plugin for BitlBee"
HOMEPAGE="https://github.com/bitlbee/bitlbee-facebook"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

if [[ ${PV} == *9999 ]] ; then
	inherit	git-r3
	EGIT_REPO_URI="https://github.com/bitlbee/bitlbee-facebook"
else
	SRC_URI="https://github.com/bitlbee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	>=net-im/bitlbee-3[plugins]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
