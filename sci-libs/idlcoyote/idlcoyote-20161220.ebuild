# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} != 99999999 ]]; then
	SRC_URI="http://www.idlcoyote.com/programs/zip_files/coyoteprograms.zip -> ${P}.zip"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/coyote"
	DEPEND="app-arch/unzip"
else
	inherit git-r3
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/idl-coyote/coyote.git"
	KEYWORDS=""
fi

DESCRIPTION="GDL library from D. Fannings IDL courses"
HOMEPAGE="http://www.idlcoyote.com/"

LICENSE="BSD GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-lang/gdl"

src_install() {
	dodoc README.txt
	rm README.txt || die
	insinto /usr/share/gnudatalanguage/coyote
	doins -r *
}
