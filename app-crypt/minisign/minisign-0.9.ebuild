# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Dead simple tool to sign files and verify signatures"
HOMEPAGE="https://github.com/jedisct1/minisign"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jedisct1/${PN}.git"
else
	SRC_URI="https://github.com/jedisct1/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~hppa ~ia64 ~ppc64 ~sparc"
fi

LICENSE="ISC"
SLOT="0"

IUSE=""

DEPEND=">=dev-libs/libsodium-1.0.16:=[-minimal]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( -DCMAKE_STRIP="${EPREFIX}/bin/true" )
	cmake_src_configure
}
