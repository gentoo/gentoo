# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux tool to dump x86 CPUID information about the CPUs"
HOMEPAGE="http://www.etallen.com/cpuid.html"
SRC_URI="http://www.etallen.com/${PN}/${P}.src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	app-arch/gzip
	dev-lang/perl
"

DOCS=( "ChangeLog" "FUTURE" )

PATCHES=( "${FILESDIR}/${PN}-20200203-makefile.patch" )

src_prepare() {
	default

	tc-export CC
}

src_install() {
	emake BUILDROOT="${ED}" install

	einstalldocs
}
