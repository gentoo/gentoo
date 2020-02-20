# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A pure bash session or application launcher. Inspired by cdm, tdm and krunner"
HOMEPAGE="https://loh-tar.github.io/tbsm/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/loh-tar/tbsm.git"
else
	SRC_URI="https://github.com/loh-tar/tbsm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="app-shells/bash:0"
RDEPEND="${DEPEND}"
