# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of post-processing shaders written for ReShade"
HOMEPAGE="https://reshade.me https://github.com/crosire/reshade-shaders"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/crosire/${PN}.git"
	KEYWORDS=""
	inherit git-r3
else
	inherit vcs-snapshot
	GIT_COMMIT="323bca357dec59e147cb9b00150b66c144965c6d"
	SRC_URI="https://github.com/crosire/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="BSD"
SLOT="0"

src_install() {
	insinto /usr/share/${PN}
	doins -r Shaders Textures
}
