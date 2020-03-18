# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Dead simple tool to sign files and verify signatures"
HOMEPAGE="https://github.com/jedisct1/minisign"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jedisct1/${PN}.git"
else
	SRC_URI="https://github.com/jedisct1/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="ISC"
SLOT="0"

IUSE=""

DEPEND=">=dev-libs/libsodium-1.0.16:=[-minimal]"
RDEPEND="${DEPEND}"
