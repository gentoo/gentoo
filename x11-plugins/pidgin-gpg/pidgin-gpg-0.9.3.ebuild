# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools ltprune

DESCRIPTION="Pidgin GPG/OpenPGP (XEP-0027) plugin"
HOMEPAGE="https://github.com/Draghtnod/Pidgin-GPG"
SRC_URI="https://github.com/Draghtnod/Pidgin-GPG/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-crypt/gpgme
	net-im/pidgin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/Pidgin-GPG-${PV}"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --all
}
