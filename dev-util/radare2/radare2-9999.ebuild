# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

is_live() { [[ ${PV} == 9999* ]]; }

is_live && inherit git-r3

DESCRIPTION="Advanced command line hexadecimal editor and more"
HOMEPAGE="http://www.radare.org"
is_live || SRC_URI="http://www.radare.org/get/${P}.tar.xz"
EGIT_REPO_URI="https://github.com/radare/radare2"

LICENSE="GPL-2"
SLOT="0"
IUSE="ssl +system-capstone"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
	system-capstone? ( dev-libs/capstone:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	econf \
		$(use_with ssl openssl) \
		$(use_with system-capstone syscapstone)
}
