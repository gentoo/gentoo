# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ functions matching the interface and behavior of python string methods"
HOMEPAGE="https://github.com/imageworks/pystring"

if [[ "${PV}" == "9999" ]];  then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/imageworks/pystring.git"
else
	SRC_URI="https://github.com/imageworks/pystring/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="dev-build/libtool"

PATCHES=(
	# Patch to convert the project into cmake. Taken from:
	# https://github.com/imageworks/pystring/pull/29
	"${FILESDIR}/cmake.patch"
)
