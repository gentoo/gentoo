# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic eutils

DESCRIPTION="Standard tool to compile source trees"
HOMEPAGE="https://www.gnu.org/software/make/make.html"
SRC_URI="mirror://gnu//make/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="guile nls static"

CDEPEND="guile? ( >=dev-scheme/guile-1.8:= )"
DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${CDEPEND}
	nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.82-darwin-library_search-dylib.patch
	"${FILESDIR}"/${PN}-4.2-default-cxx.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_configure() {
	use static && append-ldflags -static
	econf \
		--program-prefix=g \
		$(use_with guile) \
		$(use_enable nls)
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
