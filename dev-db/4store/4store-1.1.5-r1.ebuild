# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="4store is an efficient, scalable and stable RDF database"
HOMEPAGE="http://4store.org/"
# http://4store.org/download/4store-v1.0.4.tar.gz
MY_P="${PN}-v${PV}"
SRC_URI="http://4store.org/download/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# < http://4store.org/trac/wiki/Dependencies
DEPEND="media-libs/raptor
		>=dev-libs/rasqal-0.9.18
		dev-libs/glib
		dev-libs/libxml2
		dev-libs/libpcre
		sys-libs/readline
		sys-libs/ncurses
		dev-libs/expat
		sys-libs/zlib"

RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup fourstore
	enewuser  fourstore -1 -1 /var/lib/4store fourstore
}

src_install() {

	# patch the Makefiles to use /usr/ instead of /usr/local/
	find . -name "Makefile" -execdir sed -e "s#/usr/local/#/usr/#" -i {} \;

	MAKEOPTS="-j1" emake DESTDIR="${D}" install || die "emake install failed"

	dodir /var/log/4store
	fowners fourstore:fourstore \
		/var/lib/4store \
		/var/log/4store

	# fix 1777
	fperms 755 /var/lib/4store

	# fix 755
	fperms 644 \
		/usr/share/man/man1/4s-query.1 \
		/usr/share/man/man1/4s-backend-setup.1 \
		/usr/share/man/man1/4s-import.1 \
		/usr/share/man/man1/4s-cluster-info.1 \
		/usr/share/man/man1/4s-cluster-start.1 \
		/usr/share/man/man1/4s-cluster-create.1 \
		/usr/share/man/man1/4s-cluster-stop.1 \
		/usr/share/man/man1/4s-cluster-destroy.1
}
