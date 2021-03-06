# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
USE_RUBY="ruby25 ruby26 ruby27"
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=no

LUA_COMPAT=( lua5-{1..3} )

inherit autotools distutils-r1 lua-single ruby-single

DESCRIPTION="Prelude-SIEM Framework Library"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua perl python ruby"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="net-libs/gnutls:=
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )"

DEPEND="${RDEPEND}"

BDEPEND=">=dev-lang/swig-4.0.0
	dev-util/gtk-doc-am
	sys-devel/flex
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl:= virtual/perl-ExtUtils-MakeMaker )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-fix-python-bindings.patch"
	"${FILESDIR}/${PN}-5.1.0-fix_gtkdoc_1.32.patch"
	"${FILESDIR}/${PN}-5.2.0-luabindings_liblua.patch"
)

src_prepare() {
	default

	# Avoid null runpaths in Perl bindings.
	sed -e 's/ LD_RUN_PATH=""//' -i "${S}/bindings/Makefile.am" || die "sed failed"

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
		--without-python2
		--localstatedir="${EPREFIX}/var"
		$(use_with lua)
		$(use_with perl)
		$(usex perl '--with-perl-installdirs=vendor' '')
		$(use_with ruby)
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

	keepdir /var/spool/prelude
}
