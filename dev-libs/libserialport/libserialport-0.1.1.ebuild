# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils ltprune

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Cross platform serial port access library"
HOMEPAGE="https://sigrok.org/wiki/Libserialport"

LICENSE="LGPL-3"
SLOT="0"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
