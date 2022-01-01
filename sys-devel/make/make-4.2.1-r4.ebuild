# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic

DESCRIPTION="Standard tool to compile source trees"
HOMEPAGE="https://www.gnu.org/software/make/make.html"
SRC_URI="mirror://gnu//make/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="guile nls static"

CDEPEND="guile? ( >=dev-scheme/guile-1.8:= )"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.82-darwin-library_search-dylib.patch
	"${FILESDIR}"/${PN}-4.2-default-cxx.patch
	"${FILESDIR}"/${PN}-4.2.1-perl526.patch
	"${FILESDIR}"/${PN}-4.2.1-glob-internals.patch
	"${FILESDIR}"/${PN}-4.2.1-pselect-non-blocking.patch
)

src_prepare() {
	default
	# These patches require special handling as they modify configure.ac
	# which in turn triggers maintainer-mode when being applied the
	# usual way.
	eapply -Z "${FILESDIR}"/${PN}-4.2.1-glob-v2.patch \
		"${FILESDIR}"/${P}-guile-2.2.patch
}

src_configure() {
	use static && append-ldflags -static
	local myeconfargs=(
		--program-prefix=g
		$(use_with guile)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README*
	if [[ ${USERLAND} == "GNU" ]] ; then
		# we install everywhere as 'gmake' but on GNU systems,
		# symlink 'make' to 'gmake'
		dosym gmake /usr/bin/make
		dosym gmake.1 /usr/share/man/man1/make.1
	fi
}
