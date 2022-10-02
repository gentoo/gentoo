# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://github.com/mtrojnar/osslsigncode"
SRC_URI="https://github.com/mtrojnar/osslsigncode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl"

RDEPEND="
	dev-libs/openssl:0=
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_with curl)
}
