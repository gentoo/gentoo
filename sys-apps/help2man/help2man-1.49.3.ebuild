# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU utility to convert program --help output to a man page"
HOMEPAGE="https://www.gnu.org/software/help2man/ https://salsa.debian.org/bod/help2man"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

# nls/FSFAP for bindtextdomain.c
LICENSE="GPL-3+ nls? ( FSFAP )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls"

RDEPEND="dev-lang/perl
	nls? ( dev-perl/Locale-gettext )"
DEPEND="${RDEPEND}"

# bug #385753
DOCS=( debian/changelog NEWS README THANKS )

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
	# Disable gettext requirement as the release includes the gmo files, bug #555018
	local myeconfargs=(
		ac_cv_path_MSGFMT=$(type -P false)
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}
