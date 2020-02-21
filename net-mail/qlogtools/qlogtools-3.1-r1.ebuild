# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Qmail Log processing tools"
HOMEPAGE="http://untroubled.org/qlogtools/"
SRC_URI="http://untroubled.org/qlogtools/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="!app-text/multitail"

PATCHES=(
	"${FILESDIR}"/qlogtools-3.1-errno.patch
)

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "${D}/usr/bin" > conf-bin
	echo "${D}/usr/share/man/" > conf-man
}

src_install() {
	dodir /usr/bin /usr/share/man/
	./installer || die "Installer failed"
	dodoc ANNOUNCEMENT FILES NEWS README TARGETS VERSION
}

pkg_postinst() {
	elog "Please see /usr/share/doc/${PF}/README for configuration information"
}
