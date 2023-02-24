# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool

DESCRIPTION="IPC library used by GnuPG and GPGME"
HOMEPAGE="https://www.gnupg.org/related_software/libassuan/index.en.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Note: On each bump, update dep bounds on each version from configure.ac!
# We need >= 1.28 for gpgrt_malloc
RDEPEND=">=dev-libs/libgpg-error-1.28"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	if [[ ${CHOST} == *-solaris* ]] ; then
		elibtoolize

		# fix standards conflict
		sed -i \
			-e '/_XOPEN_SOURCE/s/500/600/' \
			-e 's/_XOPEN_SOURCE_EXTENDED/_NO&/' \
			-e 's/__EXTENSIONS__/_NO&/' \
			configure || die
	fi
}

src_configure() {
	local myeconfargs=(
		--disable-static
		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# ppl need to use libassuan-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}
