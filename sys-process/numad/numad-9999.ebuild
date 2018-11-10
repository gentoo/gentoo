# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://pagure.io/numad.git"
	inherit git-r3
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86 -arm -s390"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

CONFIG_CHECK="~NUMA ~CPUSETS"

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu99"
}

src_install() {
	emake prefix="${ED}/usr" install
}
