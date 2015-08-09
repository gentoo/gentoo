# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit latex-package versionator

DESCRIPTION="LaTeX package for rendering high-quality chemical structure diagrams"
HOMEPAGE="http://xymtex.com/"
MY_PV="$(delete_all_version_separators)"
SRC_URI="${HOMEPAGE}/fujitas3/${PN}/xym${MY_PV}/xym-up/${PN}${MY_PV}.zip"
LICENSE="LPPL-1.3"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

TEXMF=/usr/share/texmf-site

src_compile() {
	local subdir
	for subdir in base chemist xymtxpdf xymtxps; do
		cd "${S}/${subdir}" || die
		latex-package_src_compile
	done
}

src_install() {
	local subdir
	for subdir in base chemist xymtxpdf xymtxps; do
		cd "${S}/${subdir}" || die
		latex-package_src_install
	done

	# cd "${S}/doc/doc${MY_PV}/" || die
	cd "${S}/doc/doc500/" || die
	latex-package_src_doinstall pdf
}
