# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="The vc (version control) bundle"
HOMEPAGE="https://www.ctan.org/pkg/vc"
# Taken from http://mirrors.ctan.org/support/vc.zip
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.zip"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "${TEXMF}"/scripts/${PN}
	doins -r bzr-unix git-unix hg-unix svn-unix
	latex-package_src_doinstall pdf
	dodoc CHANGES README
}
