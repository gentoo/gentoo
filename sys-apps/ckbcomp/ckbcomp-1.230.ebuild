# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Compile an XKB keymap for loadkeys"
HOMEPAGE="https://salsa.debian.org/installer-team/console-setup"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anonscm.debian.org/git/d-i/console-setup.git"
else
	SRC_URI="https://salsa.debian.org/installer-team/console-setup/-/archive/${PV}/console-setup-${PV}.tar.gz"
	S="${WORKDIR}"/console-setup-${PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-lang/perl
	sys-apps/kbd
	x11-misc/xkeyboard-config
"

src_compile() {
	:
}

src_install() {
	dobin Keyboard/ckbcomp
}
