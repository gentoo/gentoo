# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A Qt-based interface to system statistics"
HOMEPAGE="https://lxqt.github.io/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-0.6.0"
DEPEND="dev-qt/qtcore:5"
RDEPEND="${DEPEND}"
