# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

MY_PN="${PN/-/}-avh"
COMP_PN="${PN}-completion"
COMP_PV="0.6.0"
COMP_P="${COMP_PN}-${COMP_PV}"

DESCRIPTION="Git extensions to provide high-level repository operations"
HOMEPAGE="https://github.com/petervanderdoes/gitflow-avh"
SRC_URI="https://github.com/petervanderdoes/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/petervanderdoes/${COMP_PN}/archive/${COMP_PV}.tar.gz -> ${COMP_P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="dev-vcs/git"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.3_scriptdir.patch
)

DOCS=( AUTHORS CHANGELOG.md README.md )

S="${WORKDIR}"/${MY_PN}-${PV}

src_prepare() {
	default
	sed -i "s!doc/gitflow!doc/${PF}!" Makefile || die "Fixing doc path failed"
	sed -i "s!@PREFIX@!${EPREFIX}/usr!" git-flow || die "Failed to set prefix in the script"
}

src_compile() {
	true
}

src_install() {
	emake prefix="${ED}"/usr install
	einstalldocs
	newbashcomp "${WORKDIR}"/${COMP_P}/${COMP_PN}.bash ${PN}
}
