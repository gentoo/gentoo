# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )
USE_RUBY="ruby22 ruby23 ruby24 ruby25"
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1 ruby-single

DESCRIPTION="Framework to easy access to the Prelude database"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres python sqlite"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="~dev-libs/libprelude-${PV}
	net-libs/gnutls:=
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	>=dev-lang/swig-3.0.11
	dev-util/gtk-doc-am
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-fix-python-bindings.patch"
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
		--with-swig
		$(use_with mysql)
		$(use_with postgres postgresql)
		$(use_with sqlite sqlite3)
	)

	if use python; then
		python_setup
		if python_is_python3; then
			myconf+=(--without-python2 --with-python3="${EPYTHON}")
		else
			myconf+=(--without-python3 --with-python2="${EPYTHON}")
		fi
	else
		myconf+=(--without-python2 --without-python3)
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
