# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="https://github.com/axel-download-accelerator/axel"
SRC_URI="https://github.com/axel-download-accelerator/axel/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 ~riscv sparc x86"
IUSE="debug nls ssl"

CDEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libintl virtual/libiconv )"

DOCS=( doc/. )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl)
}

pkg_postinst() {
	einfo 'To use axel with Portage, one can configure make.conf with:'
	einfo
	einfo 'FETCHCOMMAND="axel --timeout=30 --alternate --no-clobber --output=\"\${DISTDIR}/\${FILE}\" \"\${URI}\""'
	einfo 'RESUMECOMMAND="axel --timeout=30 --alternate --no-clobber --output=\"\${DISTDIR}/\${FILE}\" \"\${URI}\""'
}
