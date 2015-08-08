# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_DEPEND="python? 2"
PYTHON_USE_WITH="threads"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

USE_PHP="php5-4"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

inherit java-pkg-opt-2 mono-env php-ext-source-r2 python

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="java lua mono perl php python ruby tcl"
REQUIRED_USE="|| ( java lua mono perl php python ruby tcl )"

COMMONDEPEND="=dev-libs/xapian-${PV}*
	lua? ( dev-lang/lua:= )
	mono? ( >=dev-lang/mono-1.0.8 )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:= )
	tcl? ( >=dev-lang/tcl-8.1:0= )"
DEPEND="${COMMONDEPEND}
	java? ( >=virtual/jdk-1.3 )"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.3 )"

pkg_setup() {
	mono-env_pkg_setup
	java-pkg-opt-2_pkg_setup

	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	if use python; then
		sed \
			-e 's|\(^pkgpylib_DATA = xapian/__init__.py\).*|\1|' \
			-e '/\s\sxapian\/__init__.pyc/d' \
			-e '/\s\sxapian\/__init__.pyo/d' \
			-e 's|\(^xapian/__init__.py: modern/xapian.py\)|\1 xapian/_xapian$(PYTHON_SO)|' \
			-i python/Makefile.in || die "sed failed"
	fi
}

src_configure() {
	if use java; then
		CXXFLAGS="${CXXFLAGS} $(java-pkg_get-jni-cflags)"
	fi

	if use perl; then
		export PERL_ARCH="$(perl -MConfig -e 'print $Config{installvendorarch}')"
		export PERL_LIB="$(perl -MConfig -e 'print $Config{installvendorlib}')"
	fi

	if use lua; then
		export LUA_LIB="$(pkg-config --variable=INSTALL_CMOD lua)"
	fi

	econf \
		$(use_with java) \
		$(use_with lua) \
		$(use_with mono csharp) \
		$(use_with perl) \
		$(use_with php) \
		$(use_with python) \
		$(use_with ruby) \
		$(use_with tcl)

	# Python bindings are built/tested/installed manually.
	sed -e "/SUBDIRS =/s/ python//" -i Makefile || die "sed Makefile"
}

src_compile() {
	default

	if use python; then
		python_copy_sources python
		building() {
			emake \
				PYTHON="$(PYTHON)" \
				PYTHON_INC="$(python_get_includedir)" \
				PYTHON_LIB="$(python_get_libdir)" \
				PYTHON_SO="$("$(PYTHON)" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_config_vars("SO")[0])')" \
				pkgpylibdir="$(python_get_sitedir)/xapian"
		}
		python_execute_function -s --source-dir python building
	fi
}

src_test() {
	default

	if use python; then
		testing() {
			emake \
				PYTHON="$(PYTHON)" \
				PYTHON_INC="$(python_get_includedir)" \
				PYTHON_LIB="$(python_get_libdir)" \
				PYTHON_SO="$("$(PYTHON)" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_config_vars("SO")[0])')" \
				pkgpylibdir="$(python_get_sitedir)/xapian" \
				VERBOSE="1" \
				check
		}
		python_execute_function -s --source-dir python testing
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use java; then
		java-pkg_dojar java/built/xapian_jni.jar
		# TODO: make the build system not install this...
		java-pkg_doso "${D}/${S}/java/built/libxapian_jni.so"
		rm "${D}/${S}/java/built/libxapian_jni.so"
		rmdir -p "${D}/${S}/java/built"
		rmdir -p "${D}/${S}/java/native"
	fi

	if use python; then
		installation() {
			emake \
				DESTDIR="${D}" \
				PYTHON="$(PYTHON)" \
				PYTHON_INC="$(python_get_includedir)" \
				PYTHON_LIB="$(python_get_libdir)" \
				PYTHON_SO="$("$(PYTHON)" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_config_vars("SO")[0])')" \
				pkgpylibdir="$(python_get_sitedir)/xapian" \
				install
		}
		python_execute_function -s --source-dir python installation
	fi

	if use php; then
		php-ext-source-r2_createinifiles
	fi

	# For some USE combinations this directory is not created
	if [[ -d "${D}/usr/share/doc/xapian-bindings" ]]; then
		mv "${D}/usr/share/doc/xapian-bindings" "${D}/usr/share/doc/${PF}"
	fi

	dodoc AUTHORS HACKING NEWS TODO README || die "dodoc failed"
}

pkg_postinst() {
	if use python; then
		python_mod_optimize xapian
	fi

	if use php_targets_php5-4; then
		ewarn "Note: subclassing Xapian classes in PHP currently doesn't work with PHP 5.4"
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup xapian
	fi
}
