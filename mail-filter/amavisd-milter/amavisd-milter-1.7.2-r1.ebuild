# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="sendmail milter for amavisd-new"
HOMEPAGE="https://github.com/prehor/amavisd-milter/"
SRC_URI="https://github.com/prehor/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="mail-filter/libmilter:="
RDEPEND="${DEPEND}
	mail-filter/amavisd-new"

DOCS=( AMAVISD-MILTER.md CHANGES INSTALL )

src_install() {
	default

	newinitd "${FILESDIR}/amavisd-milter.initd-r2" amavisd-milter
	newconfd "${FILESDIR}/amavisd-milter.confd" amavisd-milter
}
