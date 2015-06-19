# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/ykneo-ccid-tools/ykneo-ccid-tools-0.0.0.ebuild,v 1.2 2013/09/13 15:42:23 wschlich Exp $

EAPI=5

inherit eutils udev

DESCRIPTION="Tools for Yubico's YubiKey NEO in CCID mode"
SRC_URI="http://yubico.github.io/ykneo-ccid-tools/releases/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/ykneo-ccid-tools"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-2"
IUSE=""

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	sys-apps/help2man
	dev-util/gengetopt"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	epatch "${FILESDIR}/${P}-string.patch"
}
