# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Set environment variables with OS X keychain or D-Bus Secret Service"
HOMEPAGE="https://github.com/sorah/envchain"
SRC_URI="https://github.com/sorah/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
sys-libs/readline:*
app-crypt/libsecret
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}/usr" install
}
