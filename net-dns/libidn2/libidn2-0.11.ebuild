# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2"
SRC_URI="mirror://gnu-alpha/libidn/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND="
	sys-apps/help2man
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10-examples.patch
	"${FILESDIR}"/${PN}-0.10-Werror.patch
)

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static)
}

multilib_src_install() {
	default

	prune_libtool_files
}
