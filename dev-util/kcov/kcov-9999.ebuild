# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Kcov is a code coverage tester for compiled languages, Python and Bash"
HOMEPAGE="https://github.com/SimonKagstrom/kcov"
LICENSE="GPL-2"
SLOT="0"

if [ "${PV}" -eq 9999 ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SimonKagstrom/${PN}.git"
else
	SRC_URI="https://github.com/SimonKagstrom/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	dev-libs/elfutils
	net-misc/curl
	sys-devel/binutils:*
	sys-libs/zlib"
DEPEND="${RDEPEND}"
