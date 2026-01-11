# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
EAPI=8

inherit cmake

DESCRIPTION="A fast and consistent wire protocol for IPC"
HOMEPAGE="https://github.com/hyprwm/hyprwire"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="gui-libs/hyprutils"
DEPEND="${RDEPEND}"
BDEPEND="|| ( >=sys-devel/gcc-15:* >=llvm-core/clang-20:* )"

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return
}
