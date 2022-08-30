# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/libidn.asc
inherit multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2 https://gitlab.com/libidn/libidn2"
SRC_URI="
	mirror://gnu/libidn/${P}.tar.gz
	verify-sig? ( mirror://gnu/libidn/${P}.tar.gz.sig )
"
S="${WORKDIR}"/${P/a/}

LICENSE="GPL-2+ LGPL-3+"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static-libs"

RDEPEND="
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	sys-apps/help2man
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-libidn )
"

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Darwin ar chokes when TMPDIR doesn't exist (as done for some
		# reason in the Makefile)
		sed -i -e '/^TMPDIR = /d' Makefile.in || die
		export TMPDIR="${T}"
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		CC_FOR_BUILD="$(tc-getBUILD_CC)" \
		$(use_enable static-libs static) \
		$(multilib_native_use_enable nls) \
		--disable-doc \
		--disable-gcc-warnings \
		--disable-gtk-doc
}

multilib_src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
