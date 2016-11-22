# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="GNU utility to convert program --help output to a man page"
HOMEPAGE="https://www.gnu.org/software/help2man/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="dev-lang/perl
	nls? ( dev-perl/Locale-gettext )"
DEPEND=${RDEPEND}

DOCS="debian/changelog NEWS README THANKS" #385753

PATCHES=(
	"${FILESDIR}"/${PN}-1.46.1-linguas.patch
)

src_prepare() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i \
			-e 's/-shared/-bundle/' \
			Makefile.in || die
	fi
	epatch "${PATCHES[@]}"
}

src_configure() {
	# Disable gettext requirement as the release includes the gmo files #555018
	econf \
		ac_cv_path_MSGFMT=$(type -P false) \
		$(use_enable nls)
}
