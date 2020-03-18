# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
USE_RUBY="ruby24 ruby25 ruby26"
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1 ruby-single

DESCRIPTION="Prelude-SIEM Framework Library"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/5.1.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua perl python ruby"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="net-libs/gnutls:=
	lua? ( dev-lang/lua:* )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )"

DEPEND="${RDEPEND}"

BDEPEND=">=dev-lang/swig-3.0.11
	dev-util/gtk-doc-am
	sys-devel/flex
	lua? ( dev-lang/lua:* )
	perl? ( dev-lang/perl:= virtual/perl-ExtUtils-MakeMaker )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-fix-python-bindings.patch"
	"${FILESDIR}/${PN}-5.1.0-fix_awk_error.patch"
	"${FILESDIR}/${PN}-5.1.0-fix_gtkdoc_1.32.patch"
	"${FILESDIR}/${PN}-5.1.0-fix_py38.patch"
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
		$(use_with lua)
		$(use_with perl)
		$(usex perl '--with-perl-installdirs=vendor' '')
		$(use_with ruby)
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
