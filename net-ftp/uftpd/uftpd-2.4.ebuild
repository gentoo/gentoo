# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The no nonsense TFTP/FTP server."
HOMEPAGE="https://github.com/troglobit/uftpd"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libite
	dev-libs/libuev
	!!net-misc/uftp"

RDEPEND="${DEPEND}"
