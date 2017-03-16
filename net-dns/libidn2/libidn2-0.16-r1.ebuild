# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2 https://gitlab.com/jas/libidn2"
SRC_URI="
	mirror://gnu-alpha/libidn/${P}.tar.gz
"

LICENSE="GPL-2+ LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	dev-libs/libunistring[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	sys-apps/help2man
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12-Werror.patch
	"${FILESDIR}"/${PN}-0.12-examples.patch
	"${FILESDIR}"/${PN}-0.16-gengetopt.patch
	"${FILESDIR}"/${PN}-0.16-cross.patch
	"${FILESDIR}"/${PN}-pkgconfig.diff
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
