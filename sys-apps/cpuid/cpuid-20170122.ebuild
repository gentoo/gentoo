# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Utility to get detailed information about the CPU(s) using the CPUID instruction"
HOMEPAGE="http://www.etallen.com/cpuid.html"
SRC_URI="http://www.etallen.com/${PN}/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	app-arch/gzip
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-20170122-Makefile.patch
	"${FILESDIR}"/${PN}-20170122-missing-include-sysmacros.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	emake BUILDROOT="${ED}" install
	einstalldocs
}
