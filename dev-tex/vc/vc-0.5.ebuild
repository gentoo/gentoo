# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package

DESCRIPTION="The vc (version control) bundle"
HOMEPAGE="https://www.ctan.org/pkg/vc"
# Taken from http://mirrors.ctan.org/support/vc.zip
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"
PATCHES=(
	"${FILESDIR}"/${P}-git-date.patch
	"${FILESDIR}"/${P}-git-status.patch
)

src_compile() { :; }

src_install() {
	insinto ${TEXMF}/scripts/${PN}
	doins -r bzr-unix git-unix svn-unix
	latex-package_src_doinstall pdf
	dodoc CHANGES README
}
