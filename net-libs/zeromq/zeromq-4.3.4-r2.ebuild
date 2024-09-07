# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="A brokerless kernel"
HOMEPAGE="https://zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/5"
KEYWORDS="amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="doc drafts +libbsd pgm +sodium static-libs test unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	!elibc_Darwin? ( unwind? ( sys-libs/libunwind ) )
	libbsd? ( dev-libs/libbsd:= )
	sodium? ( dev-libs/libsodium:= )
"
DEPEND="
	${RDEPEND}
	!elibc_Darwin? ( sys-apps/util-linux )
"
BDEPEND="
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	pgm? ( virtual/pkgconfig )
"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-13.patch
	"${FILESDIR}"/${P}-qemu-user.patch
)

src_prepare() {
	sed \
		-e '/libzmq_werror=/s:yes:no:g' \
		-i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		--without-pgm
		$(use_enable drafts)
		$(use_enable libbsd)
		$(use_enable static-libs static)
		$(use_enable unwind libunwind)
		$(use_with sodium libsodium)
		$(use_with doc docs)
	)
	# Force bash for configure until the fixes for bug #923922 land in a release
	# https://github.com/zeromq/zproject/pull/1336
	# https://github.com/zeromq/libzmq/pull/4651
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_test() {
	# Restricting to one job because multiple tests are using the same port.
	# Upstream knows the problem and says it doesn't support parallel test
	# execution, see ${S}/INSTALL.
	emake -j1 check
}

src_install() {
	default
	find "${ED}"/usr/lib* -name '*.la' -delete || die
}
