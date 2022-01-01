# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="https://think-async.com https://github.com/chriskohlhoff/asio"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="doc examples libressl ssl test"
RESTRICT="!test? ( test )"
# test searches for libssl during ./configure, and REQUIRED_USE is easier than
# patching configure to not search for it with USE=-ssl
REQUIRED_USE="test? ( ssl )"

RDEPEND="dev-libs/boost
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default

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
	fi
}
