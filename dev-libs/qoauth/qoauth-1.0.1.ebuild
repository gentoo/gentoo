# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qoauth/qoauth-1.0.1.ebuild,v 1.14 2015/02/22 18:32:01 mgorny Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="A Qt-based library for OAuth support"
HOMEPAGE="http://wiki.github.com/ayoy/qoauth"
SRC_URI="http://files.ayoy.net/qoauth/release/${PV}/src/${P}-src.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="debug doc static-libs test"

COMMON_DEPEND="app-crypt/qca:2[debug?,qt4(+)]"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:4 )
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2[openssl]
"

S=${WORKDIR}/${P}-src

DOCS="README CHANGELOG"
PATCHES=(
	# disable functional tests that require network connection
	# and rely on 3rd party external server (bug #341267)
	"${FILESDIR}/${P}-disable-ft.patch"
)

src_prepare() {
	qt4-r2_src_prepare

	if ! use test; then
		sed -i -e '/SUBDIRS/s/tests//' ${PN}.pro || die "sed failed"
	fi

	sed -i -e '/^ *docs \\$/d' \
		-e '/^ *build_all \\$/d' \
		-e 's/^\#\(!macx\)/\1/' \
		src/src.pro || die "sed failed"

	sed -i -e "s/\(.*\)lib$/\1$(get_libdir)/" src/pcfile.sh || die "sed failed"
}

src_compile() {
	default
	if use static-libs; then
		emake -C src static
	fi
}

src_install() {
	qt4-r2_src_install

	if use static-libs; then
		dolib.a "${S}"/lib/lib${PN}.a
	fi

	if use doc; then
		doxygen "${S}"/Doxyfile || die "failed to generate documentation"
		dohtml "${S}"/doc/html/*
	fi
}
