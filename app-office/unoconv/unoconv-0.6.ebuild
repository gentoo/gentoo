# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
EGIT_REPO_URI="https://github.com/dagwieers/unoconv.git"
[[ ${PV} == 9999* ]] && SCM_ECLASS="git-2"
inherit eutils python ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="Convert between document formats supported by Libreoffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
[[ ${PV} == 9999* ]] || SRC_URI="https://github.com/dagwieers/${PN}/tarball/${PV} -> ${P}-git.tar.gz"

LICENSE="GPL-2"
SLOT="0"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999* ]] || \
KEYWORDS="amd64 x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!app-text/odt2txt
	virtual/ooo
"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	mv "${WORKDIR}"/dagwieers-${PN}-* "${WORKDIR}"/${P}
	cd "${S}"

	epatch "${FILESDIR}/timeout.patch"
	python_convert_shebangs -r 2 .
}

src_compile() { :; }

src_install() {
	emake -j1 doc-install install install-links DESTDIR="${D}" || die

	dodoc ChangeLog README.asciidoc || die
}
