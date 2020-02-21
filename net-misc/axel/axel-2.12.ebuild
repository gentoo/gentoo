# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="https://github.com/eribertomota/axel"
SRC_URI="https://github.com/eribertomota/axel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris"
IUSE="debug libressl nls ssl"

CDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libintl virtual/libiconv )"

DOCS=( doc/. )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with ssl openssl)
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND='\''axel -a -o "\${DISTDIR}/\${FILE}.axel" "\${URI}" && mv "\${DISTDIR}/\${FILE}.axel" "\${DISTDIR}/\${FILE}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
