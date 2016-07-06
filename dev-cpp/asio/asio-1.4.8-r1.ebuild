# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="http://asio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="doc examples ssl test"

RDEPEND="ssl? ( dev-libs/openssl )
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

	# Added ASIO_DECL to a number of function definitions
	# http://sourceforge.net/tracker/?func=detail&aid=3291113&group_id=122478&atid=694037
	epatch "${FILESDIR}/${P}_declarations.patch"
}

src_install() {
	default

	if use doc; then
		dohtml -r doc/*
	fi

	if use examples; then
		if use test; then
			# Get rid of the object files
			emake clean
		fi
		dodoc -r src/examples
	fi
}
