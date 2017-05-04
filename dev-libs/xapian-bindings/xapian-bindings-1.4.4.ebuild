# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="threads(+)"

USE_PHP="php5-6"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

inherit distutils-r1 libtool java-pkg-opt-2 mono-env php-ext-source-r2 toolchain-funcs

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="java lua mono perl php python ruby tcl"
REQUIRED_USE="|| ( java lua mono perl php python ruby tcl )"

COMMONDEPEND="dev-libs/xapian:0/30
	lua? ( dev-lang/lua:= )
	perl? ( dev-lang/perl:= )
	python? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	ruby? ( dev-lang/ruby:= )
	tcl? ( dev-lang/tcl:= )
	mono? ( dev-lang/mono )"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.6 )"

pkg_setup() {
	use mono && mono-env_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare

	# http://trac.xapian.org/ticket/702
	export XAPIAN_CONFIG="/usr/bin/xapian-config"

	# Accept ruby 2.0 - patch configure directly to avoid autoreconf
	epatch "${FILESDIR}"/${PN}-1.3.6-allow-ruby-2.0.patch

	if use python; then
		python_copy_sources
	fi
}

src_configure() {
	local conf=(
		--disable-documentation
		--without-csharp
		--without-python
		--without-python3
	)

	if use java; then
		export CXXFLAGS="${CXXFLAGS} $(java-pkg_get-jni-cflags)"
		conf+=( --with-java )
	fi

	if use perl; then
		export PERL_ARCH="$(perl -MConfig -e 'print $Config{installvendorarch}')"
		export PERL_LIB="$(perl -MConfig -e 'print $Config{installvendorlib}')"
		conf+=( --with-perl )
	fi

	if use lua; then
		export LUA_LIB="$($(tc-getPKG_CONFIG) --variable=INSTALL_CMOD lua)"
		conf+=( --with-lua )
	fi

	if use php; then
		if has_version "=dev-lang/php-7*"; then
			conf+=( --with-php7 )
		else
			conf+=( --with-php )
		fi
	fi

	use ruby && conf+=( --with-ruby )
	use tcl  && conf+=( --with-tcl )
	use mono && conf+=( --with-csharp )

	econf ${conf[@]}

	python_configure() {
		local myconf=(
			--disable-documentation
			--without-java
			--without-lua
			--without-csharp
			--without-perl
			--without-php
			--without-ruby
			--without-tcl
		)
		if python_is_python3; then
			myconf+=( --with-python3 )
		else
			myconf+=( --with-python )
		fi

		# Avoid sandbox failures when compiling modules
		addpredict "$(python_get_sitedir)"

		econf "${myconf[@]}"
	}

	if use python; then
		python_foreach_impl run_in_build_dir python_configure
	fi
}

src_compile() {
	default
	if use python; then
		unset PYTHONDONTWRITEBYTECODE
		python_foreach_impl run_in_build_dir emake
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use java; then
		java-pkg_dojar java/built/xapian_jni.jar
		# TODO: make the build system not install this...
		java-pkg_doso java/.libs/libxapian_jni.so
		rm -rf "${D}var" || die "could not remove java cruft!"
	fi

	use php && php-ext-source-r2_createinifiles

	if use python; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	fi

	# For some USE combinations this directory is not created
	if [[ -d "${D}/usr/share/doc/xapian-bindings" ]]; then
		mv "${D}/usr/share/doc/xapian-bindings" "${D}/usr/share/doc/${PF}" || die
	fi

	dodoc AUTHORS HACKING NEWS TODO README
}
