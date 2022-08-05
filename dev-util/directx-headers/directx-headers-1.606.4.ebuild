# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=DirectX-Headers
inherit meson-multilib

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/microsoft/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/microsoft/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/${MY_PN}-${PV}
fi

DESCRIPTION="DirectX header files and WSL stubs"
HOMEPAGE="https://github.com/microsoft/DirectX-Headers"

LICENSE="MIT"
SLOT="0"

multilib_src_configure() {
	local emesonargs=(
		-Dbuild-test=false
	)

	meson_src_configure
}
