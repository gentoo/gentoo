# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake-utils llvm

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="https://embed.cs.utah.edu/creduce/"
SRC_URI="https://embed.cs.utah.edu/creduce/${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-lang/perl-5.10.0
	>=sys-devel/clang-5:="
RDEPEND="${COMMON_DEPEND}
	dev-perl/Benchmark-Timer
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/Getopt-Tabular
	dev-perl/Regexp-Common
	dev-perl/Sys-CPU
	dev-util/astyle
	dev-util/indent"
DEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-llvm-5.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}
