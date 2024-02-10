# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="A simple CLI tool that display file system usage, with colors"
HOMEPAGE="https://projects.gw-computing.net/projects/dfc"
SRC_URI="https://projects.gw-computing.net/attachments/download/615/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
IUSE="nls"

DEPEND="nls? (
	virtual/libintl
	sys-devel/gettext
)"
RDEPEND="nls? ( virtual/libintl )"

src_configure() {
	local mycmakeargs=(
		# avoid installing xdg config in /usr
		-DXDG_CONFIG_DIR="${EPREFIX}"/etc/xdg
		# use the standard Gentoo doc path
		-DDFC_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		# disable automagic dependency
		-DNLS_ENABLED="$(usex nls)"
		-DLFS_ENABLED=ON
	)

	cmake_src_configure
}
