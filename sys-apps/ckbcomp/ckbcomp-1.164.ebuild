# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Compile an XKB keymap for loadkeys"
HOMEPAGE="https://anonscm.debian.org/cgit/d-i/console-setup.git"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anonscm.debian.org/git/d-i/console-setup.git"
else
	COMMIT_ID=e327df26fa9dbdf363b778ada91e83967f4bd500
	SRC_URI="https://anonscm.debian.org/cgit/d-i/console-setup.git/snapshot/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${COMMIT_ID}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="
	dev-lang/perl:*
	sys-apps/kbd
	x11-misc/xkeyboard-config"

src_compile() {
	:
}

src_install() {
	dobin Keyboard/ckbcomp
}
