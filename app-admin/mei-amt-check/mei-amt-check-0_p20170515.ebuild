# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot linux-info toolchain-funcs

DESCRIPTION="AMT status checker"
HOMEPAGE="https://github.com/mjg59/mei-amt-check/"
COMMIT="d07672120ce7a0c79e949e537f3d19efecec1700"
SRC_URI="https://github.com/mjg59/mei-amt-check/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CONFIG_CHECK="~INTEL_MEI_ME"
ERROR_INTEL_MEI_ME="Need to activate INTEL_MEI_ME to run the tool"

src_prepare() {
	default
	sed -i -e "/CC :=/d" Makefile || die
}

src_compile() {
	CC=$(tc-getCC) emake all
}

src_install() {
	dosbin ${PN}
	dodoc README.md
}
