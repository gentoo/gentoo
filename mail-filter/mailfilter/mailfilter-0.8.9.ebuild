# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
HOMEPAGE="https://mailfilter.sourceforge.io/"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"
IUSE="+ssl"

PATCHES=(
	"${FILESDIR}"/${PV}-bashisms.patch
	"${FILESDIR}"/${PV}-prototypes.patch
)

DEPEND="sys-devel/flex
	ssl? ( dev-libs/openssl:= )"
RDEPEND="ssl? ( dev-libs/openssl:= )"

src_configure() {
	econf $(use_with ssl openssl)
}

src_install() {
	default
	dodoc INSTALL doc/FAQ "${FILESDIR}"/rcfile.example{1,2}
}
