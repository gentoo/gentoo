# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake llvm

EGIT_COMMIT="2a4480eb6cb72b3d2d131b536c883cc6d41bdcaa"
DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="https://embed.cs.utah.edu/creduce/"
SRC_URI="https://github.com/csmith-project/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LLVM_MAX_SLOT=9

DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.10.0
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/Getopt-Tabular
	dev-perl/Regexp-Common"
BDEPEND="
	>=dev-lang/perl-5.10.0
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/creduce-2.11.0-link-libs.patch
)

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}
