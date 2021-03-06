# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit autotools distutils-r1

DESCRIPTION="Framework to easy access to the Prelude database"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/tmp/libpreludedb-5.1.0-update_m4_postgresql.patch"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres python sqlite"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/libprelude-5.2.0
	<dev-libs/libprelude-6
	net-libs/gnutls:=
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}"

BDEPEND=">=dev-lang/swig-4.0.0
	dev-util/gtk-doc-am
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	python? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-fix-python-bindings.patch"
	"${FILESDIR}/${PN}-5.1.0-fix_gtkdoc_1.32.patch"
	"${DISTDIR}/${PN}-5.1.0-update_m4_postgresql.patch"
)

src_prepare() {
	default

	eautoreconf

	if use python; then
		cd bindings/python || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	local myconf=(
		--enable-easy-bindings
		--without-swig
		--without-python2
		--localstatedir="${EPREFIX}/var"
		$(use_with mysql)
		$(use_with postgres postgresql)
		$(use_with sqlite sqlite3)
	)

	if use python; then
		python_setup
		myconf+=( --with-python3="${EPYTHON}" )
	else
		myconf+=( --without-python3 )
	fi

	econf "${myconf[@]}"
}

src_compile() {
	default
	if use python; then
		cd bindings/python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	if use python; then
		cd bindings/python || die
		distutils-r1_src_install
	fi
}
