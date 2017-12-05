# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam

DESCRIPTION="PAM module for authenticating against PKCS#11 tokens"
HOMEPAGE="https://github.com/opensc/pam_p11/wiki"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="virtual/pam
		dev-libs/libp11
		dev-libs/openssl:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dopammod src/.libs/pam_p11_opensc.so
	dopammod src/.libs/pam_p11_openssh.so
}
