# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake-utils llvm

EGIT_COMMIT="48e622ba74bc35c5a81299d3a34b9b14038d6a70"

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="https://embed.cs.utah.edu/creduce/"
SRC_URI="https://github.com/csmith-project/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"

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
	dev-perl/Regexp-Common
	dev-perl/Sys-CPU"
DEPEND="${COMMON_DEPEND}
	sys-devel/flex"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=(
	"${FILESDIR}"/creduce-llvm-7.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}
