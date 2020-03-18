# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Crackle cracks BLE Encryption (AKA Bluetooth Smart)"
HOMEPAGE="http://lacklustre.net/projects/crackle/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mikeryan/crackle.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="http://lacklustre.net/projects/crackle/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
		test? ( dev-lang/perl )"

src_install() {
	DESTDIR="${ED}" PREFIX=/usr emake install
}
