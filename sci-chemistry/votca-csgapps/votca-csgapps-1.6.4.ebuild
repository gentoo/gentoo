# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
else
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
	S="${WORKDIR}/${P#votca-}"
fi

DESCRIPTION="Extra applications for votca-csg"
HOMEPAGE="https://www.votca.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-cpp/eigen-3.3
	~sci-chemistry/${PN%apps}-${PV}
"
DEPEND="${RDEPEND}"

DOCS=( README.md )
