# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="LXQt localisation package"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.3.1
	>=lxqt-base/liblxqt-0.11.1
"
