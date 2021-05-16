# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="0.9.6"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="Facebook protocol plugin for libpurple"
HOMEPAGE="https://github.com/dequis/purple-facebook"
SRC_URI="https://github.com/dequis/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-libs/json-glib
	 net-im/pidgin"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog NEWS README VERSION )

src_prepare() {
	default
	eautoreconf
}
