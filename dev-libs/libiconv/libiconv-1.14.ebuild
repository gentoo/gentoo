# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit libtool toolchain-funcs

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="!sys-libs/glibc
	!sys-apps/man-pages"
RDEPEND="${DEPEND}"

src_prepare() {
	# Make sure that libtool support is updated to link "the linux way"
	# on FreeBSD.
	elibtoolize
}

src_configure() {
	# Disable NLS support because that creates a circular dependency
	# between libiconv and gettext
	econf \
		--docdir="\$(datarootdir)/doc/${PF}/html" \
		--disable-nls \
		--enable-shared \
		--enable-static
}

src_install() {
	default

	# Install in /lib as utils installed in /lib like gnutar
	# can depend on this
	gen_usr_ldscript -a iconv charset
}
