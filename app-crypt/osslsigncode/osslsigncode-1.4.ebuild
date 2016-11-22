# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://sourceforge.net/projects/osslsigncode"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_with curl)
}
