# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P}-BlameMichelson.src"
DESCRIPTION="A powerful text processing tool, mainly used for spam filtering"
HOMEPAGE="http://crm114.sourceforge.net/"
SRC_URI="http://crm114.sourceforge.net/tarballs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples mew nls normalizemime test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/tre
	mew? ( app-emacs/mew )
	normalizemime? ( mail-filter/normalizemime )"
DEPEND="${RDEPEND}
	test? ( sys-apps/miscfiles )"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-fix-makefile.patch )

src_prepare() {
	default

	if use normalizemime; then
		sed \
			-e 's%#:mime_decoder: /normalizemime/%:mime_decoder: /normalizemime/%' \
			-e 's%:mime_decoder: /mewdecode/%#:mime_decoder: /mewdecode/%' \
			-i mailfilter.cf || die
	fi
}

src_compile() {
	# Restore GNU89 inline semantics to
	# emit external symbols, bug 571062
	append-cflags -std=gnu89 -fcommon

	emake CC="$(tc-getCC)"
}

src_test() {
	emake megatest
}

src_install() {
	dobin crm114 cssdiff cssmerge cssutil osbf-util

	insinto /usr/share/${PN}
	doins *.crm *.cf *.mfp

	dodoc COLOPHON.txt CRM114_Mailfilter_HOWTO.txt FAQ.txt INTRO.txt QUICKREF.txt \
		CLASSIFY_DETAILS.txt inoc_passwd.txt KNOWNBUGS.txt THINGS_TO_DO.txt README

	if use examples; then
		docinto examples
		dodoc *.example
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	elog "The spam-filter CRM files are installed in ${EROOT}/usr/share/${PN}."
}
