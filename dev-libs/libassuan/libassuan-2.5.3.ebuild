# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool

DESCRIPTION="IPC library used by GnuPG and GPGME"
HOMEPAGE="http://www.gnupg.org/related_software/libassuan/index.en.html"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgpg-error-1.8"
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
	econf \
		$(use_enable static-libs static) \
		GPG_ERROR_CONFIG="${EROOT}/usr/bin/${CHOST}-gpg-error-config" \
		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
}

src_install() {
	default
	# ppl need to use libassuan-config for --cflags and --libs
	find "${ED}" -type f -name '*.la' -delete || die
}
