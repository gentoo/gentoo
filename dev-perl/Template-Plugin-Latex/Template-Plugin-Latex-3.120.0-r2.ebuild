# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EHUELS
DIST_VERSION=3.12
inherit perl-module

DESCRIPTION="LaTeX support for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/LaTeX-Driver-0.70.0
	>=dev-perl/LaTeX-Encode-0.20.0
	dev-perl/LaTeX-Table
	>=dev-perl/Template-Toolkit-2.160.0
	app-text/texlive[xetex]
"
src_test() {
	LATEX_TESTING=1	perl-module_src_test
}

DEPEND="${RDEPEND}"
