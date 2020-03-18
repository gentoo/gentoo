# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Extra applications for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-cpp/eigen-3.3
	~sci-chemistry/${PN%apps}-${PV}"

DEPEND="${RDEPEND}"

DOCS=( README )
