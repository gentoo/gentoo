# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="High-performance asynchronous messaging library"
HOMEPAGE="https://zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="doc drafts +libbsd +sodium static-libs test unwind"
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
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.5-c99.patch
)

src_prepare() {
	default

	# Only here for the c99 configure patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-Werror
		--enable-shared
		$(use_enable drafts)
		$(use_enable libbsd)
		$(use_enable static-libs static)
		$(use_enable unwind libunwind)
		$(use_with sodium libsodium)
		$(use_with doc docs)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# Restricting to one job because multiple tests are using the same port.
	# Upstream knows the problem and says it doesn't support parallel test
	# execution, see ${S}/INSTALL.
	emake -j1 check
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
