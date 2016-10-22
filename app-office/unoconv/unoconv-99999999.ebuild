# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
EGIT_REPO_URI="https://github.com/dagwieers/unoconv.git"
[[ ${PV} == 9999* ]] && SCM_ECLASS="git-r3"
inherit python-single-r1 ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="Convert between document formats supported by Libreoffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
[[ ${PV} == 9999* ]] || SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	!app-text/odt2txt
	virtual/ooo
"

DOCS=( ChangeLog CHANGELOG.md README.adoc )

PATCHES=( "${FILESDIR}/timeout.patch" )

src_compile() { :; }

src_install() {
	emake doc-install install install-links DESTDIR="${D}" || die
	einstalldocs
	python_fix_shebang .
}
