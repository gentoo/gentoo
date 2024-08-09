# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="https://think-async.com https://github.com/chriskohlhoff/asio"
SRC_URI="https://downloads.sourceforge.net/asio/asio/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"
IUSE="doc examples test"
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
	use doc && local HTML_DOCS=( doc/. )
	default

	if use examples; then
		# Get rid of the object files
		emake clean
		dodoc -r src/examples
		docompress -x /usr/share/doc/${PF}/examples

		# Make links to the example .cpp files work
		# https://bugs.gentoo.org/828648
		if use doc; then
			dosym ../examples /usr/share/doc/${PF}/src/examples
		fi
	fi
}
