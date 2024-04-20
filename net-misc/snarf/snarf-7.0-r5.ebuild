# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOCONF="2.1"
inherit autotools toolchain-funcs

DESCRIPTION="Small and fast CLI resource grabber for http, gopher, finger, ftp"
HOMEPAGE="https://www.xach.com/snarf/"
SRC_URI="https://www.xach.com/snarf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/snarf-basename-patch.diff
	"${FILESDIR}"/snarf-unlink-empty.diff
	"${FILESDIR}"/snarf-fix-off-by-ones.diff
	"${FILESDIR}"/snarf-fix-build-for-clang16.patch
)

src_prepare() {
	default
	eautoconf
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin snarf
	doman snarf.1
	dodoc ChangeLog README TODO
}

pkg_postinst() {
	elog 'To use snarf with portage, try these settings in your make.conf'
	elog
	elog '	FETCHCOMMAND="/usr/bin/snarf -b \${URI} \${DISTDIR}/\${FILE}"'
	elog '	RESUMECOMMAND="/usr/bin/snarf -rb \${URI} \${DISTDIR}/\${FILE}"'
}
