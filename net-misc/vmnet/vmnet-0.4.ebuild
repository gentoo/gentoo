# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A simple virtual networking program - SLIP over stdin/out"
HOMEPAGE="ftp://ftp.xos.nl/pub/linux/vmnet/"
# The main site is often down
# So this might be better but it's a different filename
# http://ftp.debian.org/debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.gz
# We use the debian patch anyway
SRC_URI="ftp://ftp.xos.nl/pub/linux/${PN}/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}-1.diff.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="sys-apps/net-tools"
DEPEND=${RDEPEND}

PATCHES=(
	"${WORKDIR}"/${P/-/_}-1.diff
)

src_compile() {
	append-ldflags -Wl,-z,now
	emake
}

src_install() {
	dobin ${PN}
	fperms 4711 /usr/bin/${PN}

	doman ${PN}.1
	dodoc README debian/${PN}.sgml

	insinto /etc
	doins debian/${PN}.conf
}

pkg_postinst() {
	einfo "Don't forgot to ensure SLIP support is in your kernel!"
}
