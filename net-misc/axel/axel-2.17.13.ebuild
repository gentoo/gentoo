# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="https://github.com/axel-download-accelerator/axel"
SRC_URI="https://github.com/axel-download-accelerator/axel/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="nls ssl"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}
	nls? ( virtual/libintl virtual/libiconv )"
BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( doc/. )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl ssl=openssl)
}

pkg_postinst() {
	einfo 'To use axel with Portage, one can configure make.conf with:'
	einfo
	einfo 'FETCHCOMMAND="axel --timeout=30 --alternate --no-clobber --output=\"\${DISTDIR}/\${FILE}\" \"\${URI}\""'
	einfo 'RESUMECOMMAND="axel --timeout=30 --alternate --no-clobber --output=\"\${DISTDIR}/\${FILE}\" \"\${URI}\""'
}
