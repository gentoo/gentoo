# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcitx/fcitx-m17n"
fi

DESCRIPTION="m17n-provided input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx-m17n"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://download.fcitx-im.org/${PN}/${P}.tar.xz"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/fcitx-4.2.8
	dev-libs/m17n-lib
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=()

PATCHES=(
	"${FILESDIR}/${P}-memory_leak.patch"
)
