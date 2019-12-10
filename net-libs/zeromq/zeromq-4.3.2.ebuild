# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="A brokerless kernel"
HOMEPAGE="http://www.zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/5"
KEYWORDS="amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc drafts pgm +sodium static-libs test unwind elibc_Darwin"
RESTRICT="!test? ( test )"

RDEPEND="
	!elibc_Darwin? ( unwind? ( sys-libs/libunwind ) )
	sodium? ( dev-libs/libsodium:= )
	pgm? ( =net-libs/openpgm-5.2.122 )"
DEPEND="${RDEPEND}
	!elibc_Darwin? ( sys-apps/util-linux )
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	pgm? ( virtual/pkgconfig )"

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
		$(use_enable drafts)
		$(use_enable static-libs static)
		$(use_enable unwind libunwind)
		$(use_with sodium libsodium)
		$(use_with pgm)
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
	find "${ED%/}"/usr/lib* -name '*.la' -delete || die
}
