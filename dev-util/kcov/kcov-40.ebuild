# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit cmake python-any-r1

DESCRIPTION="Kcov is a code coverage tester for compiled languages, Python and Bash"
HOMEPAGE="https://github.com/SimonKagstrom/kcov"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/SimonKagstrom/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/SimonKagstrom/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+binutils"

RDEPEND="dev-libs/elfutils
	net-misc/curl
	sys-libs/zlib
	binutils? ( sys-libs/binutils-libs:= )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${P}-binutils-2.39.patch
	"${FILESDIR}"/${P}-gcc-13.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Bfd=$(usex !binutils)

		-DKCOV_INSTALL_DOCDIR=share/doc/${PF}
	)

	cmake_src_configure
}
