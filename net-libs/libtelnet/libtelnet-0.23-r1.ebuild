# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/seanmiddleditch/libtelnet.git"
	inherit git-r3 cmake
else
	inherit autotools
	SRC_URI="https://github.com/seanmiddleditch/libtelnet/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple RFC-compliant TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"

LICENSE="public-domain"
SLOT="0"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/doxygen
	virtual/pkgconfig
"

src_prepare() {
	default
	if [[ ${PV} = *9999 ]]; then
		eapply "${FILESDIR}"/${P}-doc.patch
		cmake_src_prepare
	else
		eautoreconf
	fi
}
