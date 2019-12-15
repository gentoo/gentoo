# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Linux tool to dump x86 CPUID information about the CPUs"
HOMEPAGE="http://www.etallen.com/cpuid.html"
SRC_URI="http://www.etallen.com/${PN}/${P}.src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="dev-lang/perl"
DEPEND="app-arch/gzip"

DOCS=( "ChangeLog" "FUTURE" )

PATCHES=(
	"${FILESDIR}/${P}-add-spec-ctrl-output.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_prepare() {
	default

	tc-export CC
}

src_install() {
	emake BUILDROOT="${ED}" install

	einstalldocs
}
