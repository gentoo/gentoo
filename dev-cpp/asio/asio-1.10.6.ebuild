# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="http://asio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples ssl test"

RDEPEND="ssl? ( dev-libs/openssl:0= )
	>=dev-libs/boost-1.35.0"
DEPEND="${RDEPEND}"

src_prepare() {
	if ! use test; then
		# Don't build nor install any examples or unittests
		# since we don't have a script to run them
		cat > src/Makefile.in <<-EOF
all:

install:
		EOF
	fi
	default
}

src_install() {
	default

	if use examples; then
		if use test; then
			# Get rid of the object files
			emake clean
		fi
		dodoc -r src/examples
	fi
	if use doc; then
		docinto /usr/share/doc/${PF}/html
		dodoc -r doc/*
	fi
}
