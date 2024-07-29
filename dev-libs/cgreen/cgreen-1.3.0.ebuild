# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Unit test and mocking framework for C and C++"
HOMEPAGE="https://cgreen-devs.github.io/"
SRC_URI="https://github.com/cgreen-devs/cgreen/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="sys-libs/glibc:="
RDEPEND="${DEPEND}"

PATCHES=(
	#Patch to fix git directory detection see https://github.com/cgreen-devs/cgreen/issues/234
	"${FILESDIR}/${P}-cmake-git.patch"
)
