# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE="threads(+)"

USE_PHP="php5-6 php7-1 php7-2"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

USE_RUBY="ruby22 ruby23 ruby24"
RUBY_OPTIONAL="yes"

inherit java-pkg-opt-2 mono-env multibuild php-ext-source-r3 python-r1 ruby-ng toolchain-funcs

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="https://www.xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~ia64 ~mips ppc ppc64 ~sparc ~x86"
IUSE="java lua mono perl php python ruby tcl"
REQUIRED_USE="|| ( java lua mono perl php python ruby tcl )
	python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( || ( $(ruby_get_use_targets) ) )"

COMMONDEPEND=">=dev-libs/xapian-1.4.7:0/30
	lua? ( dev-lang/lua:= )
	perl? ( dev-lang/perl:= )
	python? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	ruby? ( $(ruby_implementations_depend) )
	tcl? ( dev-lang/tcl:= )
	mono? ( dev-lang/mono )"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.6 )"

S="${WORKDIR}/${P}"

has_basic_bindings() {
	# Update this list if new bindings are added that are not built
	# multiple times for multiple versions like php, python and ruby are
	return $(use mono || use java || use lua || use perl || use tcl)
}

php_copy_sources() {
	local MULTIBUILD_VARIANTS=($(php_get_slots))
	multibuild_copy_sources
}

php_foreach_impl() {
	local MULTIBUILD_VARIANTS=($(php_get_slots))
	multibuild_foreach_variant "$@"
}

ruby_copy_sources() {
	local MULTIBUILD_VARIANTS=($(ruby_get_use_implementations))
	multibuild_copy_sources
}

ruby_foreach_impl() {
	local MULTIBUILD_VARIANTS=($(ruby_get_use_implementations))
	multibuild_foreach_variant "$@"
}

pkg_setup() {
	use mono && mono-env_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
}

src_unpack() {
	default

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			# Unfortunately required for php-ext-source-r3_createinifiles().
			mkdir "${WORKDIR}/${php_slot}"
		done
	fi
}

src_prepare() {
	use java && java-pkg-opt-2_src_prepare

	# https://trac.xapian.org/ticket/702
	export XAPIAN_CONFIG="/usr/bin/xapian-config"

	if use php; then
		php_copy_sources
	fi

	if use python; then
		python_copy_sources
	fi

	if use ruby; then
		ruby_copy_sources
	fi

	eapply_user
}

src_configure() {
	if has_basic_bindings ; then
		local conf=(
			--disable-documentation
			$(use_with mono csharp)
			$(use_with java)
			$(use_with lua)
			$(use_with perl)
			$(use_with tcl)
			--without-php
			--without-php7
			--without-python
			--without-python3
			--without-ruby
		)

		if use java; then
			local -x CXXFLAGS="${CXXFLAGS} $(java-pkg_get-jni-cflags)"
		fi

		if use perl; then
			local -x PERL_ARCH="$(perl -MConfig -e 'print $Config{installvendorarch}')"
			local -x PERL_LIB="$(perl -MConfig -e 'print $Config{installvendorlib}')"
		fi

		if use lua; then
			local -x LUA_INC="$("$(tc-getPKG_CONFIG)" --variable=INSTALL_INC lua)"
			local -x LUA_LIB="$("$(tc-getPKG_CONFIG)" --variable=INSTALL_CMOD lua)"
		fi

		econf "${conf[@]}"
	fi

	php_configure() {
		local myconf=(
			--disable-documentation
			--without-java
			--without-lua
			--without-csharp
			--without-perl
			--without-python
			--without-python3
			--without-ruby
			--without-tcl
		)
		if [[ ${MULTIBUILD_VARIANT} == php5.* ]]; then
			myconf+=(
				--with-php
				--without-php7
			)
			local -x PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${MULTIBUILD_VARIANT/-/.}/bin/php-config"
		elif [[ ${MULTIBUILD_VARIANT} == php7.* ]]; then
			myconf+=(
				--without-php
				--with-php7
			)
			local -x PHP_CONFIG7="${EPREFIX}/usr/$(get_libdir)/${MULTIBUILD_VARIANT/-/.}/bin/php-config"
		fi

		econf "${myconf[@]}"
	}

	if use php; then
		addpredict /usr/share/snmp/mibs/.index
		addpredict /var/lib/net-snmp/mib_indexes

		php_foreach_impl run_in_build_dir php_configure
	fi

	python_configure() {
		local myconf=(
			--disable-documentation
			--without-java
			--without-lua
			--without-csharp
			--without-perl
			--without-php
			--without-php7
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

	ruby_configure() {
		local myconf=(
			--disable-documentation
			--without-java
			--without-lua
			--without-csharp
			--without-perl
			--without-php
			--without-php7
			--without-python
			--without-python3
			--with-ruby
			--without-tcl
		)
		local -x RUBY="${EPREFIX}/usr/bin/${MULTIBUILD_VARIANT}"

		econf "${myconf[@]}"
	}

	if use ruby; then
		ruby_foreach_impl run_in_build_dir ruby_configure
	fi
}

src_compile() {
	if has_basic_bindings ; then
		default
	fi

	if use php; then
		php_foreach_impl run_in_build_dir emake
	fi

	if use python; then
		unset PYTHONDONTWRITEBYTECODE
		python_foreach_impl run_in_build_dir emake
	fi

	if use ruby; then
		ruby_foreach_impl run_in_build_dir emake
	fi
}

src_test() {
	if has_basic_bindings ; then
		default
	fi

	if use php; then
		php_foreach_impl run_in_build_dir emake check
	fi

	if use python; then
		python_foreach_impl run_in_build_dir emake check
	fi

	if use ruby; then
		ruby_foreach_impl run_in_build_dir emake check
	fi
}

src_install() {
	if has_basic_bindings ; then
		emake DESTDIR="${D}" install
	fi

	if use java; then
		java-pkg_dojar java/built/xapian.jar
		# TODO: make the build system not install this...
		java-pkg_doso java/.libs/libxapian_jni.so
		rm -rf "${D}var" || die "could not remove java cruft!"
	fi

	if use php; then
		php_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
		php-ext-source-r3_createinifiles
		# php-ext-source-r3_createinifiles() changes current directory.
		cd "${S}"
	fi

	if use python; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	fi

	if use ruby; then
		ruby_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	fi

	# For some USE combinations this directory is not created
	if [[ -d "${D}/usr/share/doc/xapian-bindings" ]]; then
		mv "${D}/usr/share/doc/xapian-bindings" "${D}/usr/share/doc/${PF}" || die
	fi

	dodoc AUTHORS HACKING NEWS TODO README
}
