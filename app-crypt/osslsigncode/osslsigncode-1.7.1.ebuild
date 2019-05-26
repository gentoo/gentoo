# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://sourceforge.net/projects/osslsigncode"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl libressl"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	curl? ( net-misc/curl )
	!libressl? ( =dev-libs/openssl-1.0*:0= )
	libressl? ( dev-libs/libressl:0= )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_with curl)
}
