# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alisarctl.asc
inherit autotools verify-sig

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource"
HOMEPAGE="https://github.com/alisarctl/davfs2"
SRC_URI="
	mirror://nongnu/${PN}/${P}.tar.gz
	verify-sig? ( mirror://nongnu/${PN}/${P}.tar.gz.sig )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="nls verify-sig"
RESTRICT="test"

DEPEND="
	net-libs/neon:="
RDEPEND="
	${DEPEND}
	acct-group/davfs2
	acct-user/davfs2
	nls? (
		virtual/libintl
		virtual/libiconv
	)"
BDEPEND="
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-alisarctl )
"

src_prepare() {
	default

	# apply the patch by sed, upstream uses meson now
	# see https://github.com/alisarctl/davfs2/pull/28
	sed -i -E '/AC_CHECK_HEADERS\(\[error.h/{
		s/error\.h[[:space:]]*//g
		a\
		AC_CHECK_HEADER([error.h], [AC_CHECK_FUNC([error], AC_DEFINE([HAVE_ERROR_H], [1], [Define if error.h is usable]))])
}' configure.ac || die

	eautoreconf
}

src_configure() {
	econf --enable-largefile $(use_enable nls)
}

pkg_postinst() {
	elog
	elog "Quick setup:"
	elog "   (as root)"
	elog "   # gpasswd -a \${your_user} davfs2"
	elog "   # echo 'https://path/to/dav /home/\${your_user}/dav davfs rw,user,noauto  0  0' >> /etc/fstab"
	elog "   (as user)"
	elog "   \$ mkdir -p ~/dav"
	elog "   \$ mount ~/dav"
	elog
}
