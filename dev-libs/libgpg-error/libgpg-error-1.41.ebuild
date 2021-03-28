# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool multilib-minimal toolchain-funcs prefix

DESCRIPTION="Contains error handling functions used by GnuPG software"
HOMEPAGE="https://www.gnupg.org/related_software/libgpg-error"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp nls static-libs"

RDEPEND="nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gpg-error-config
)
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/gpg-error.h
	/usr/include/gpgrt.h
)

PATCHES=(
	"${FILESDIR}/${PN}-1.37-remove_broken_check.patch"
)

src_prepare() {
	default

	if use prefix ; then
		# don't hardcode /usr/xpg4/bin/sh as shell on Solaris
		sed -i -e 's/solaris\*/disabled/' configure.ac || die
	fi

	# only necessary for as long as we run eautoreconf, configure.ac
	# uses ./autogen.sh to generate PACKAGE_VERSION, but autogen.sh is
	# not a pure /bin/sh script, so it fails on some hosts
	hprefixify -w 1 autogen.sh
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_is_native_abi || echo --disable-languages)
		$(use_enable common-lisp languages)
		$(use_enable nls)
		# required for sys-power/suspend[crypt], bug 751568
		$(use_enable static-libs static)
		--enable-threads
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
