# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ fast hash map and hash set using robin hood hashing"
HOMEPAGE="https://github.com/Tessil/robin-map"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Tessil/robin-map"
else
	SRC_URI="https://github.com/Tessil/robin-map/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

LICENSE="MIT"
SLOT="0"
