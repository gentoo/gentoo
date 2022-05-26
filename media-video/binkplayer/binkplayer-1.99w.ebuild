# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bink Video! Player"
HOMEPAGE="http://www.radgametools.com/default.htm"
# No version on the archives and upstream has said they are not
# interested in providing versioned archives.
SRC_URI="mirror://gentoo/${P}.zip"
S="${WORKDIR}"

# distributable per http://www.radgametools.com/binkfaq.htm
LICENSE="freedist"
SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]"
BDEPEND="app-arch/unzip"

QA_PREBUILT="opt/bin/BinkPlayer"

src_install() {
	into /opt
	dobin BinkPlayer
}
