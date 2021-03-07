# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/-/}"

DESCRIPTION="Run a network service at low privilege level and restricted file system access"
HOMEPAGE="ftp://ftp.porcupine.org/pub/security/index.html"
SRC_URI="ftp://ftp.porcupine.org/pub/security/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~ia64 ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dodoc README chrootuid_license
	dobin chrootuid
	doman chrootuid.1
}
