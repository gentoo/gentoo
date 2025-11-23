# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="TOML for Modern C++"
HOMEPAGE="https://toruniina.github.io/toml11/
	https://github.com/ToruNiina/toml11/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ToruNiina/${PN}.git"
else
	SRC_URI="https://github.com/ToruNiina/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( README.md README_ja.md )
