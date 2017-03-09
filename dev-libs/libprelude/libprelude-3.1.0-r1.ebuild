# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

USE_RUBY="ruby21"

inherit autotools python-r1 ruby-single

DESCRIPTION="Prelude-SIEM Framework Library"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc lua python ruby perl"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libgcrypt:0=
	net-libs/gnutls:=
	perl? ( dev-lang/perl:= virtual/perl-ExtUtils-MakeMaker )
	lua? ( dev-lang/lua:* )
	ruby? ( ${RUBY_DEPS} )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	sys-devel/flex
	virtual/yacc
	>=dev-lang/swig-3.0.7
	virtual/pkgconfig"

src_prepare() {
	default

	# Avoid null runpaths in Perl bindings.
	sed -e 's/ LD_RUN_PATH=""//' -i "${S}/bindings/Makefile.am" || die "sed failed"

	eautoreconf
}

src_configure() {
	local python2_configure=--without-python2
	local python3_configure=--without-python3

	chk_python() {
		if [[ ${EPYTHON} == python2* ]]; then
			python2_configure=--with-python2
		elif [[ ${EPYTHON} == python3* ]]; then
			python3_configure=--with-python3
		fi
	}

	if use python; then
		python_foreach_impl chk_python
	fi

	econf \
		--enable-easy-bindings \
		--with-swig \
		$(use_with perl) \
		$(use_with perl perl-installdirs vendor) \
		$(use_enable doc gtk-doc) \
		$(use_with lua) \
		$(use_with ruby) \
		${python2_configure} \
		${python3_configure}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
