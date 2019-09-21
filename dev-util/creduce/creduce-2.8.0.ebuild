# Copyright 1999-2019 Gentoo Authors
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

LLVM_MAX_SLOT=7

COMMON_DEPEND="
	>=dev-lang/perl-5.10.0
	sys-devel/clang:${LLVM_MAX_SLOT}"
RDEPEND="${COMMON_DEPEND}
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/Getopt-Tabular
	dev-perl/Regexp-Common"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/creduce-llvm-7.patch
	"${FILESDIR}"/creduce-2.8.0-link-libs.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}
