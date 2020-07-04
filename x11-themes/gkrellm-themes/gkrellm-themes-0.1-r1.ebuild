# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A pack of ~200 themes for GKrellM"
HOMEPAGE="http://www.muhri.net/gkrellm/"
SRC_URI="http://www.muhri.net/gkrellm/GKrellM-Skins.tar.gz"
S="${WORKDIR}"

# "keramik" says GPL, without version,
# "prime_23" contains a GPL-2 COPYING,
# all other themes have no license
LICENSE="all-rights-reserved GPL-1+ GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 sparc x86"
RESTRICT="mirror bindist"

RDEPEND=">=app-admin/gkrellm-2.1"

src_unpack() {
	unpack ${A}
	unpack GKrellM-skins/*
	rm -r GKrellM-skins || die
}

src_install() {
	insinto /usr/share/gkrellm2/themes
	doins -r *
}
