# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-single-r1

DESCRIPTION="Convert between document formats supported by LibreOffice"
HOMEPAGE="http://dag.wiee.rs/home-made/unoconv/"
SRC_URI="https://github.com/dagwieers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!app-text/odt2txt
	virtual/ooo
"

PATCHES=( "${FILESDIR}/timeout.patch" )

src_prepare() {
	default
	python_fix_shebang .
}

src_compile() { :; }

src_install() {
	emake -j1 doc-install install install-links DESTDIR="${D}"
	dodoc AUTHORS ChangeLog CHANGELOG.md README.adoc
}
