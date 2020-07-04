# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt-based library for OAuth support"
HOMEPAGE="https://github.com/ayoy/qoauth/wiki"
SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="debug doc test"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen )
"
COMMON_DEPEND="
	app-crypt/qca:2[debug?,qt5(+)]
	dev-qt/qtnetwork:5
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2[ssl]
	!dev-libs/qoauth:0
"

# disable functional tests that require network connection
# and rely on 3rd party external server (bug #341267)
PATCHES=(
	"${FILESDIR}/${PN}-1.0.1-disable-ft.patch"
	"${FILESDIR}/${P}-prf.patch"
)

src_prepare() {
	default

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

src_install() {
	if use doc; then
		doxygen "${S}"/Doxyfile || die "failed to generate documentation"
		local HTML_DOCS=( "${S}"/doc/html/. )
	fi

	INSTALL_ROOT="${D}" default
}
