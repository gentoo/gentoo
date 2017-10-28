# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_COMMIT=ce66fee6b7a1913cf89bbc60a024f0649b32c50e
# ^^ because upstream refuses to tag commits with version numbers

DESCRIPTION="The CLI inxi collects and prints hardware and system information"
HOMEPAGE="https://github.com/smxi/inxi"
SRC_URI="https://github.com/smxi/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-3.0
	sys-apps/pciutils
	sys-apps/usbutils
	"
S="${WORKDIR}/smxi-${PN}-${MY_COMMIT:0:7}"

src_install() {
	dobin "${PN}"
	unpack "./${PN}.1.gz"
	doman "${PN}.1"
}
