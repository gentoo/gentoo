# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/make.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Standard tool to compile source trees"
HOMEPAGE="https://www.gnu.org/software/make/make.html"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/make.git"
	inherit autotools git-r3
elif [[ $(ver_cut 3) -ge 90 ]] ; then
	SRC_URI="https://alpha.gnu.org/gnu/make/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://alpha.gnu.org/gnu/make/${P}.tar.gz.sig )"
else
	SRC_URI="mirror://gnu//make/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu//make/${P}.tar.gz.sig )"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="guile nls static"

DEPEND="guile? ( >=dev-scheme/guile-1.8:= )"
BDEPEND="nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-make )"
RDEPEND="${DEPEND}
	nls? ( virtual/libintl )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.82-darwin-library_search-dylib.patch
	"${FILESDIR}"/${PN}-4.2-default-cxx.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack

		cd "${S}" || die
		./bootstrap || die
	else
		default
	fi
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
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
