# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

RUBY_OPTIONAL="yes"
USE_RUBY="ruby24"

PHP_EXT_NAME="IcePHP"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

PHP_EXT_OPTIONAL_USE=php

USE_PHP="php7-0"

# This variable does not belong to any eclass. It is solely used in this ebuild
# db:6.2 breaks the build process
BERKDB_SLOTS=( 6.1 5.3 5.1 4.8 )

inherit db-use mono-env php-ext-source-r3 python-r1 ruby-ng toolchain-funcs eapi7-ver

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="https://zeroc.com/products/ice"
SRC_URI="https://github.com/zeroc-ice/ice/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://download.zeroc.com/Ice/$(ver_cut 1-2)/${P}.pdf )"
LICENSE="GPL-2"
SLOT="0/36"
KEYWORDS="amd64 ~arm x86"
IUSE="doc examples libressl +ncurses mono php python ruby test debug"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/expat-2.0.1
	>=app-arch/bzip2-1.0.5
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	|| (
		$(for slot in ${BERKDB_SLOTS[@]} ; do printf '%s\n' "sys-libs/db:${slot}[cxx]" ; done)
	)
	dev-cpp/libmcpp
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby24) )
	mono? ( dev-lang/mono )
	php? ( dev-lang/php:7.0 )
	!dev-python/IcePy
	!dev-ruby/IceRuby"
DEPEND="${RDEPEND}
	ncurses? ( sys-libs/ncurses:0= sys-libs/readline:0= )
	test? (
		${PYTHON_DEPS}
		dev-python/passlib[${PYTHON_USEDEP}]
	)"

# Maintainer notes:
# TODO: java bindings, multiple ruby versions (supports 2.{1,2,3})

S="${WORKDIR}/${P/I/i}"
PHP_EXT_S="${S}/php"

PATCHES=(
	"${FILESDIR}/${PN}-3.6.3-no-arch-opts.patch"
	"${FILESDIR}/${PN}-3.6.3-csharp.patch"
	#"${FILESDIR}/${PN}-3.6.3-libressl.patch"
)

pkg_setup() {
	# prevent ruby-ng.eclass from messing with pkg_setup
	return
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	default

	sed -i \
		-e 's|\(install_configdir[[:space:]]*\):=|\1?=|' \
		-e 's|-L\$\(libdir\)||' \
		cpp/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|\(install_phpdir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_libdir[[:space:]]*\):=|\1?=|' \
		php/config/Make.rules.php || die "sed failed"

	sed -i \
		-e 's|\(install_pythondir[[:space:]]*\)=|\1?=|' \
		-e 's|\(install_rubydir[[:space:]]*\)=|\1?=|' \
		-e 's|\(install_libdir[[:space:]]*\):=|\1?=|' \
		{python,ruby}/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|-O2 ||g' \
		-e 's|-Werror ||g' \
		cpp/config/Make.rules.Linux || die "sed failed"

	sed -i \
		-e 's|install-common||' \
		{cpp,csharp,php,python,ruby}/Makefile || die "sed failed"

	sed -i \
		-e 's|-f -root|-f -gacdir $(GAC_DIR) -root|' \
		-e 's|\(install_libdir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_pkgconfigdir[[:space:]]*\):=|\1?=|' \
		csharp/config/Make.rules.cs || die "sed failed"

	# skip mono tests, bug #498484
	sed -i \
		-e '/SUBDIRS/s|\ test||' \
		csharp/Makefile || die "sed failed"

	# skip udp test due to multicast
	# skip IceGrid/admin bug #649850
	# skip IceSSL tests due to requirement of internet connection
	# skip IceStorm/single bug #636834
	# IceStorm/stress fails without USE=debug
	# IceUtil/stacktrace fails with USE=debug
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=IceUtil\/stacktrace --rfilter=udp --rfilter=IceGrid\/admin --rfilter=IceSSL --rfilter=IceStorm\/single --rfilter=IceStorm\/stress|' \
		cpp/Makefile || die "sed failed"

	# mainly broken .ice files
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=operations --rfilter=slicing\/objects|' \
		python/Makefile || die "sed failed"

	# fails even on unicode locale
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=Slice\/unicodePaths|' \
		ruby/Makefile || die "sed failed"

	# fix for x86 IceBox test
	sed -i \
		-e 's|"32"|""|' \
		scripts/TestUtil.py || die "sed failed"
}

src_configure() {
	suitable_db_version() {
		local ver
		for ver in "${BERKDB_SLOTS[@]}"; do
			if [[ -n $(db_findver sys-libs/db:${ver}) ]]; then
				echo "${ver}"
				return 0
			fi
		done
		die "No suitable BerkDB versions found, aborting"
	}

	MAKE_RULES=(
		"prefix=\"${ED%/}/usr\""
		"install_docdir=\"${ED%/}/usr/share/doc/${PF}\""
		"install_configdir=\"${ED%/}/usr/share/${P}/config\""
		"install_mandir=\"${ED%/}/usr/share/man/man1\""
		"embedded_runpath_prefix=\"${EPREFIX}/usr\""
		"LP64=yes"
		"new_dtags=yes"
		"NOTEST=$(usex !test)"
		"USE_READLINE=$(usex ncurses)"
		"OPTIMIZE=$(usex !debug)"
	)

	local BERKDB_VERSION="$(suitable_db_version)"
	MAKE_RULES+=("DB_FLAGS=-I$(db_includedir ${BERKDB_VERSION})")
	sed -i \
		-e "s|g++|$(tc-getCXX)|" \
		-e "s|\(CFLAGS[[:space:]]*=\)|\1 ${CFLAGS}|" \
		-e "s|\(CXXFLAGS[[:space:]]*=\)|\1 ${CXXFLAGS}|" \
		-e "s|\(LDFLAGS[[:space:]]*=\)|\1 ${LDFLAGS}|" \
		-e "s|\(DB_LIBS[[:space:]]*=\) \-ldb_cxx|\1 -ldb_cxx-$(db_findver sys-libs/db:${BERKDB_VERSION})|" \
		cpp/config/Make.rules{,.Linux} python/config/Make.rules || die "sed failed"

	if use python; then
		local S="${S}/python"
		python_copy_sources
	fi

	if use ruby; then
		SITERUBY="$(ruby24 -r rbconfig -e 'print RbConfig::CONFIG["sitelibdir"]')"
		MAKE_RULES_RUBY=(
			"install_rubydir=\"${ED%/}/${SITERUBY}\""
			"install_libdir=\"${ED%/}/${SITERUBY}\""
		)

		# make it use ruby24 only
		sed -i \
			-e 's|RUBY = ruby|\024|' \
			ruby/config/Make.rules || die "sed failed"
		sed -i \
			-e 's|env ruby|\024|' \
			ruby/config/s2rb.rb || die "sed failed"
		sed -i \
			-e 's|env ruby|\024|' \
			ruby/scripts/slice2rb || die "sed failed"
		sed -i \
			-e 's|output.write("ruby|\024|' \
			scripts/TestUtil.py || die "sed failed"
	fi

	MAKE_RULES_MONO=(
		"GACINSTALL=yes"
		"GAC_ROOT=\"${ED%/}/usr/$(get_libdir)\""
		"GAC_DIR=\"${EPREFIX}/usr/$(get_libdir)\""
		"install_libdir=\"${ED%/}/usr/$(get_libdir)\""
		"install_pkgconfigdir=\"${ED%/}/usr/$(get_libdir)/pkgconfig\""
	)

	if has_version ">dev-lang/mono-4"; then
		MAKE_RULES_MONO+=("MCS=mcs")
	fi

	use test && python_setup
}

src_compile() {
	# Do not remove this export or build will break!
	tc-export CXX

	emake -C cpp "${MAKE_RULES[@]}"

	if use php; then
		local i
		for i in $(php_get_slots); do
			mkdir -p "${WORKDIR}/${i}" || die
			cp -r "${PHP_EXT_S}" "${WORKDIR}/${i}/" || die "Failed to copy source ${PHP_EXT_S} to PHP target directory"

			pushd "${WORKDIR}/${i}" >/dev/null || die
			ln -s "${S}/cpp" || die
			ln -s "${S}/config" || die
			ln -s "${S}/slice" || die
			ln -s "${S}/Makefile" || die

			emake -C php "${MAKE_RULES[@]}" USE_NAMESPACES=yes "PHP_CONFIG=\"${EPREFIX}/usr/$(get_libdir)/${i}/bin/php-config\""
			popd >/dev/null || die
		done
	fi

	if use python; then
		building() {
			emake -C "${BUILD_DIR}" "${MAKE_RULES[@]}" PYTHON="${EPYTHON}"
		}
		local S="${S}/python"
		python_foreach_impl building
	fi

	if use ruby; then
		emake -C ruby "${MAKE_RULES[@]}" "${MAKE_RULES_RUBY[@]}"
	fi

	if use mono; then
		emake -C csharp "${MAKE_RULES[@]}" "${MAKE_RULES_MONO[@]}"
	fi
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}/cpp/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake -C cpp "${MAKE_RULES[@]}" test

	# php tests require the extension loaded and are therefore skipped

	if use python; then
		testing() {
			emake -C "${BUILD_DIR}" \
				"${MAKE_RULES[@]}" \
				PYTHON="${EPYTHON}" \
				install_pythondir="\"${D%/}/$(python_get_sitedir)\"" \
				install_libdir="\"${D%/}/$(python_get_sitedir)\"" test
		}
		local S="${S}/python"
		python_foreach_impl testing
	fi

	if use ruby; then
		emake -C ruby "${MAKE_RULES[@]}" "${MAKE_RULES_RUBY[@]}" test
	fi

	if use mono; then
		# skip mono tests, bug #498484
		ewarn "Tests for C# are currently disabled."
		#emake -C csharp "${MAKE_RULES[@]}" "${MAKE_RULES_MONO[@]}" test
	fi
}

src_install() {
	local DOCS=( CHANGELOG*.md README.md )
	use doc && DOCS+=( "${DISTDIR}/${P}.pdf" )
	einstalldocs

	insinto /usr/share/${P}
	doins -r slice

	emake -C cpp "${MAKE_RULES[@]}" install

	if use examples; then
		docinto examples-cpp
		dodoc cpp/config/*.cfg
		docompress -x /usr/share/doc/${PF}/examples-cpp
	fi

	if use php; then
		insinto "/usr/share/php/${PN}"

		local i
		while IFS="" read -d $'\0' -r i; do
			doins "${i}"
		done < <(find "${S}/php/lib/" -name '*.php' -print0)

		pushd "${ED%/}/usr/share/${P}/slice" >/dev/null || die

		local -x LD_LIBRARY_PATH="${ED%/}/usr/$(get_libdir):${LD_LIBRARY_PATH}"
		for i in *; do
			mkdir -p "${ED%/}/usr/share/php/${i}" || die
			"${ED%/}"/usr/bin/slice2php \
				-I"${ED%/}/usr/share/${P}/slice/" --all \
				--output-dir "${ED%/}/usr/share/php/${i}" \
				--ice "${ED%/}/usr/share/${P}/slice/${i}"/*
		done

		for i in $(php_get_slots); do
			php_init_slot_env "${i}"
			insinto "${EXT_DIR}"
			newins "php/lib/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so"
		done
		php-ext-source-r2_createinifiles

		popd >/dev/null || die
	fi

	if use python; then
		installation() {
			mkdir -p "${D%/}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" \
				"${MAKE_RULES[@]}" \
				install_pythondir="\"${D%/}/$(python_get_sitedir)\"" \
				install_libdir="\"${D%/}/$(python_get_sitedir)\"" \
				install
		}
		local S="${S}/python"
		python_foreach_impl installation
	fi

	if use ruby; then
		dodir "${SITERUBY}"
		emake -C ruby "${MAKE_RULES[@]}" "${MAKE_RULES_RUBY[@]}" install
	fi

	if use mono; then
		emake -C csharp "${MAKE_RULES[@]}" "${MAKE_RULES_MONO[@]}" install
	fi
}
