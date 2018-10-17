# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="LXQt localisation package"
HOMEPAGE="https://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="!~x11-misc/obconf-qt-0.9.0_p20150729"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.5.0
"
