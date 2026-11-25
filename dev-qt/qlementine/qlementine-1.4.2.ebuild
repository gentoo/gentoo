# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern QStyle for desktop Qt6 applications"
HOMEPAGE="https://github.com/oclero/qlementine"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/oclero/qlementine.git"
else
	SRC_URI="
		https://github.com/oclero/qlementine/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://deps.gentoo.zip/dev-qt/qlementine/${P}-build-as-shared-lib.patch
	"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-qt/qtbase:6[widgets]
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${DISTDIR}/${P}-build-as-shared-lib.patch"
)
