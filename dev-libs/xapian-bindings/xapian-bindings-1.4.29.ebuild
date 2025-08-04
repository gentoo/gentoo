# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1,3,4} luajit )

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

USE_PHP="php8-2 php8-3"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

USE_RUBY="ruby31 ruby32"
RUBY_OPTIONAL="yes"

inherit autotools java-pkg-opt-2 lua multibuild php-ext-source-r3 python-r1 ruby-ng

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="https://xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"
S="${WORKDIR}/${P}" # need this here, some inherited eclasses change it

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="java lua perl php python ruby tcl"
REQUIRED_USE="
	|| ( java lua perl php python ruby tcl )
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( || ( $(ruby_get_use_targets) ) )
"

COMMON_DEPEND="
	~dev-libs/xapian-${PV}
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl:= )
	php? ( dev-lang/php:=[-threads] )
	python? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	ruby? ( $(ruby_implementations_depend) )
	tcl? ( dev-lang/tcl:= )
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.8:* )
"
RDEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.22-remove-precompiled-python.patch
	"${FILESDIR}"/${PN}-1.4.22-fix-java-installation.patch
)

has_basic_bindings() {
	# Update this list if new bindings are added that are not built
	# multiple times for multiple versions like lua, php, python and ruby are
	return $(use java || use perl || use tcl)
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
	eapply "${PATCHES[@]}"
	eautoreconf

	use java && java-pkg-opt-2_src_prepare

	# https://trac.xapian.org/ticket/702
	export XAPIAN_CONFIG="/usr/bin/xapian-config"

	if use lua; then
		lua_copy_sources
	fi

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
	# Needed to get e.g. test failure details
	MAKEOPTS+=" VERBOSE=1"

	if has_basic_bindings ; then
		local conf=(
			--disable-documentation
			$(use_with java)
			$(use_with perl)
			$(use_with tcl)
			--without-csharp
			--without-lua
			--without-php
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

		if use tcl; then
			local tcl_version="$(echo 'puts $tcl_version;exit 0' | tclsh)"
			if [[ -z ${tcl_version} ]]; then
				die 'Unable to detect the installed version of dev-lang/tcl.'
			fi
			local -x TCL_LIB="${EPREFIX}/usr/$(get_libdir)/tcl${tcl_version}"
		fi

		econf "${conf[@]}"
	fi

	lua_configure() {
		local myconf=(
			--disable-documentation
			--without-csharp
			--without-java
			--without-perl
			--without-tcl
			--without-php
			--without-python
			--without-python3
			--without-ruby
			--with-lua
		)

		local -x LUA_INC="$(lua_get_include_dir)"
		local -x LUA_LIB="$(lua_get_cmod_dir)"

		econf "${myconf[@]}"

	}

	if use lua; then
		lua_foreach_impl run_in_build_dir lua_configure
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
			--with-php
		)
		local -x PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${MULTIBUILD_VARIANT/-/.}/bin/php-config"

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
			--without-ruby
			--without-tcl
			--with-python3
		)

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

	if use lua; then
		lua_foreach_impl run_in_build_dir emake
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

	if use lua; then
		lua_foreach_impl run_in_build_dir emake check
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
		java-pkg_doso java/.libs/libxapian_jni.so
	fi

	if use lua; then
		lua_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	fi

	if use php; then
		php_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
		php-ext-source-r3_createinifiles
		# php-ext-source-r3_createinifiles() changes current directory.
		cd "${S}"
	fi

	if use python; then
		python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
		python_foreach_impl python_optimize
	fi

	if use ruby; then
		ruby_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
		find "${ED}"/usr/share/doc/${PF}/ruby/rdocs/js -name \*.gz -delete || die
	fi

	# For some USE combinations this directory is not created
	if [[ -d "${ED}/usr/share/doc/xapian-bindings" ]]; then
		mv "${ED}/usr/share/doc/xapian-bindings" "${ED}/usr/share/doc/${PF}" || die
	fi

	dodoc AUTHORS HACKING NEWS TODO README
}
