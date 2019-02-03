# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Header-only C++ logging library"
HOMEPAGE="https://github.com/badaix/aixlog"

if [[ ${PV} == *9999 ]] ; then
	inherit cmake-utils git-r3

	EGIT_REPO_URI="https://github.com/badaix/aixlog.git"
	EGIT_BRANCH="develop"
else
	inherit cmake-utils

	SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_configure() {
	local mycmakeargs=( -DBUILD_EXAMPLE=OFF )

	cmake-utils_src_configure
}
