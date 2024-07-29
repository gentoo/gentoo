# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="https://think-async.com https://github.com/chriskohlhoff/asio"
SRC_URI="https://github.com/chriskohlhoff/asio/archive/refs/tags/asio-${PV//./-}.tar.gz"
S="${WORKDIR}/asio-asio-${PV//./-}/asio"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-libs/boost
		dev-libs/openssl
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/asio-1.30.1-pkgconfig.patch"
)

src_prepare() {
	default

	eautoreconf

	if ! use test; then
		# Don't build nor install any examples or unittests
		# since we don't have a script to run them
		cat > src/Makefile.in <<-EOF || die
			all:

			install:

			clean:
		EOF
	fi
}

src_install() {
	default

	if use examples; then
		# Get rid of the object files
		emake clean
		dodoc -r src/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
