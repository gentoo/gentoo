# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="Qt-based library for OAuth support"
HOMEPAGE="https://wiki.github.com/ayoy/qoauth"
SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="debug doc static-libs test"

COMMON_DEPEND="app-crypt/qca:2[debug?,qt5]"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2[ssl]
	!dev-libs/qoauth:0
"

DOCS=( README CHANGELOG )

src_prepare() {
	default

	# disable functional tests that require network connection
	# and rely on 3rd party external server (bug #341267)
	epatch "${FILESDIR}/${PN}-1.0.1-disable-ft.patch"

	if ! use test; then
		sed -i -e '/SUBDIRS/s/tests//' ${PN}.pro || die "sed failed"
	fi

	sed -i -e '/^ *docs \\$/d' \
		-e '/^ *build_all \\$/d' \
		-e 's/^\#\(!macx\)/\1/' \
		src/src.pro || die "sed failed"

	sed -i -e "s/\(.*\)lib$/\1$(get_libdir)/" src/pcfile.sh || die "sed failed"
}

src_configure() {
	eqmake5 qoauth.pro
}

src_compile() {
	default
	if use static-libs; then
		emake -C src static
	fi
}

src_install() {
	INSTALL_ROOT="${D}" default

	if use static-libs; then
		dolib.a "${S}"/lib/lib${PN}.a
	fi

	if use doc; then
		doxygen "${S}"/Doxyfile || die "failed to generate documentation"
		dohtml "${S}"/doc/html/*
	fi
}
