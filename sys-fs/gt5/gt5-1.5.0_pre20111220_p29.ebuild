# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV1=$(ver_cut 1-3)
MY_PV2=$(ver_cut 5)
MY_PV3=$(ver_cut 7)
MY_P1=${PN}_${MY_PV1}~${MY_PV2}+bzr${MY_PV3}
MY_P2=${PN}-${MY_PV1}~${MY_PV2}+bzr${MY_PV3}

DESCRIPTION="a diff-capable 'du-browser'"
HOMEPAGE="http://gt5.sourceforge.net/"
SRC_URI="http://deb.debian.org/debian/pool/main/g/${PN}/${MY_P1}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( www-client/links
		www-client/elinks
		www-client/lynx )"

PATCHES=(
	"${FILESDIR}/10-bug-758634.patch"
	"${FILESDIR}/20-bug-758645.patch"
)

S="${WORKDIR}/${MY_P2}"

src_prepare() {
	default
	sed -i "s|^version=.*|version=${PV}|" gt5 || die "sed failed"
}
