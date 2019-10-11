# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GNU utility to convert program --help output to a man page"
HOMEPAGE="https://www.gnu.org/software/help2man/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="dev-lang/perl
	nls? ( dev-perl/Locale-gettext )"
DEPEND=${RDEPEND}

DOCS=( debian/changelog NEWS README THANKS ) #385753

PATCHES=(
	"${FILESDIR}"/${PN}-1.46.1-linguas.patch
)

src_prepare() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i \
			-e 's/-shared/-bundle/' \
			Makefile.in || die
	fi
	default
}

src_configure() {
	# Disable gettext requirement as the release includes the gmo files #555018
	econf \
		ac_cv_path_MSGFMT=$(type -P false) \
		$(use_enable nls)
}
