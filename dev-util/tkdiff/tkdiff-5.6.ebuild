# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=${PN}-$(ver_rs 1- -)

DESCRIPTION="Graphical front end to the diff program"
HOMEPAGE="http://tkdiff.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PV}/${MYP}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-lang/tk"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MYP}"

src_install() {
	dobin tkdiff
	dodoc CHANGELOG.txt
}
