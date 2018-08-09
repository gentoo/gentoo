# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils scons-utils

DESCRIPTION="The SunPinyin IMEngine for Smart Common Input Method (SCIM)"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN#*-}/${P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-i18n/scim
	~app-i18n/sunpinyin-2.0.3
	x11-libs/gtk+:2 "
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-force-switch.patch"
}

src_compile() {
	escons --prefix="/usr"
}

src_install() {
	escons --prefix="/usr" --install-sandbox="${D}" install
}
