# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

EGIT_REPO_URI="https://github.com/csmith-project/${PN}"

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake-utils git-r3 llvm

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="https://embed.cs.utah.edu/creduce/"
SRC_URI=""

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
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
	"${FILESDIR}"/creduce-2.8.0-link-libs.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}
