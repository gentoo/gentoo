# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

USE_PHP="php5-5 php5-6"

PHP_EXT_NAME="xapian"
PHP_EXT_INI="yes"
PHP_EXT_OPTIONAL_USE="php"

#mono violates sandbox, we disable it until we figure this out
#inherit java-pkg-opt-2 mono-env php-ext-source-r2 python
inherit java-pkg-opt-2 php-ext-source-r2 python-r1 toolchain-funcs

DESCRIPTION="SWIG and JNI bindings for Xapian"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"
#IUSE="java lua mono perl php python ruby tcl"
#REQUIRED_USE="|| ( java lua mono perl php python ruby tcl )"
IUSE="java lua perl php python ruby tcl"
REQUIRED_USE="|| ( java lua perl php python ruby tcl ) python? ( ${PYTHON_REQUIRED_USE} )"

COMMONDEPEND="dev-libs/xapian:0/1.2.22
	lua? ( dev-lang/lua:0 )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:= )
	tcl? ( >=dev-lang/tcl-8.1:0= )"
#	mono? ( >=dev-lang/mono-1.0.8 )
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.3 )"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.3 )"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	if use java; then
		sed \
			-e 's/$(JAVAC)/$(JAVAC) $(JAVACFLAGS)/' \
			-i java{/,/org/xapian/errors/,/org/xapian/}Makefile.in || die "sed failed"
	fi

	if use python; then
		sed \
			-e 's:\(^pkgpylib_DATA = xapian/__init__.py\).*:\1:' \
			-e 's|\(^xapian/__init__.py: modern/xapian.py\)|\1 xapian/_xapian.so|' \
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
		export LUA_LIB="$($(tc-getPKG_CONFIG) --variable=INSTALL_CMOD lua)"
	fi

	econf \
		$(use_with java) \
		$(use_with lua) \
		$(use_with perl) \
		$(use_with php) \
		$(use_with python) \
		$(use_with ruby) \
		$(use_with tcl)
#		$(use_with mono csharp) \

	# PHP and Python bindings are built/tested/installed manually.
	sed -e "/SUBDIRS =/s/ php//" -i Makefile || die "sed Makefile"
	sed -e "/SUBDIRS =/s/ python//" -i Makefile || die "sed Makefile"
}

src_compile() {
	default

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			cp -r php php-${php_slot}
			emake -C php-${php_slot} \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)"
		done
	fi

	if use python; then
		python_copy_sources
#		building() {
#			emake -C python \
#				PYTHON="$(PYTHON)" \
#				PYTHON_INC="$(python_get_includedir)" \
#				PYTHON_LIB="$(python_get_libdir)" \
#				PYTHON_SO="$("$(PYTHON)" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_config_vars("SO")[0])')" \
#				pkgpylibdir="$(python_get_sitedir)/xapian"
#		}
		building() {
			emake -C python \
				PYTHON_INC="$(python_get_includedir)" \
				pkgpylibdir="$(python_get_sitedir)/xapian"
				VERBOSE="1"
		}
		python_foreach_impl building
	fi
}

src_test() {
	default

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			emake -C php-${php_slot} \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)" \
				check
		done
	fi

	if use python; then
		testing() {
			emake -C python \
				PYTHON_INC="$(python_get_includedir)" \
				pkgpylibdir="$(python_get_sitedir)/xapian" \
				VERBOSE="1" \
				check
		}
		python_foreach_impl testing
	fi
}

src_install () {
	emake DESTDIR="${D}" install

	if use java; then
		java-pkg_dojar java/built/xapian_jni.jar
		# TODO: make the build system not install this...
		java-pkg_doso "${D}/${S}/java/built/libxapian_jni.so"
		rm "${D}/${S}/java/built/libxapian_jni.so"
		rmdir -p "${D}/${S}/java/built"
		rmdir -p "${D}/${S}/java/native"
	fi

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			emake DESTDIR="${D}" -C php-${php_slot} \
				PHP="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php" \
				PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" \
				PHP_EXTENSION_DIR="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --extension-dir)" \
				PHP_INC="$("${EPREFIX}/usr/$(get_libdir)/${php_slot}/bin/php-config" --includes)" \
				install
		done

		php-ext-source-r2_createinifiles
	fi

	if use python; then
		installation() {
			emake -C python \
				DESTDIR="${D}" \
				PYTHON_INC="$(python_get_includedir)" \
				pkgpylibdir="$(python_get_sitedir)/xapian" \
				VERBOSE="1" \
				install
		}
		python_foreach_impl installation
	fi

	# For some USE combinations this directory is not created
	if [[ -d "${D}/usr/share/doc/xapian-bindings" ]]; then
		mv "${D}/usr/share/doc/xapian-bindings" "${D}/usr/share/doc/${PF}"
	fi

	dodoc AUTHORS HACKING NEWS TODO README
}
