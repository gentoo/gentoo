# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Endpoint turns a Linux machine with a firewire card into an SBP-2 device"
HOMEPAGE="http://oss.oracle.com/projects/endpoint/"
SRC_URI="http://oss.oracle.com/projects/endpoint/dist/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND=">=sys-libs/libraw1394-0.9
	>=dev-libs/glib-2:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-errormessages.patch
)

src_install() {
	emake -j1 install DESTDIR="${D}"
	insinto /etc
	newins docs/sample-endpoint.conf endpoint.conf
	dodoc README AUTHORS ChangeLog
}
