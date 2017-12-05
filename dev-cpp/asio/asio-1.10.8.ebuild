# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="http://asio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="doc examples ssl test"

RDEPEND="dev-libs/boost
	ssl? ( dev-libs/openssl:0= )"
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
