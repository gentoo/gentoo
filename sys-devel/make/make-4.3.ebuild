# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Standard tool to compile source trees"
HOMEPAGE="https://www.gnu.org/software/make/make.html"
if [[ "$(ver_cut 3)" -ge 90 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu//make/${P}.tar.gz"
else
	SRC_URI="mirror://gnu//make/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
LICENSE="GPL-3+"
SLOT="0"
IUSE="guile nls static"

DEPEND="guile? ( >=dev-scheme/guile-1.8:= )"
BDEPEND="nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}
	nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.82-darwin-library_search-dylib.patch
	"${FILESDIR}"/${PN}-4.2-default-cxx.patch
)

src_prepare() {
	# sources were moved into src directory
	cd src || die
	default
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
