# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Implements functions designed to lock the standard mailboxes"
HOMEPAGE="https://github.com/miquels/liblockfile"
SRC_URI="https://github.com/miquels/liblockfile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="acct-group/mail"
BDEPEND="${RDEPEND}"

DOCS=( Changelog README )

PATCHES=(
	"${FILESDIR}/${PN}-1.16-makefile.patch"
)

src_prepare() {
	default

	# I don't feel like making the Makefile portable
	if [[ ${CHOST} == *-darwin* ]] ; then
		cp "${FILESDIR}"/Makefile.Darwin.in Makefile.in || die
	fi

	eautoreconf
}

src_configure() {
	local grp=mail

	if use prefix ; then
		# We never want to use LDCONFIG
		export LDCONFIG=${EPREFIX}/bin/true
		# In unprivileged installs this is "mail"
		grp=$(id -g)
	fi

	local myeconfargs=(
		--with-mailgroup=${grp}
		--enable-shared
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}
