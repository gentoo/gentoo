# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils versionator

DESCRIPTION="LXQt localisation package"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="=lxqt-base/liblxqt-$(get_version_component_range 1-2)*"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.4.0
"
