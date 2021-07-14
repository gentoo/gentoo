# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

RUBY_OPTIONAL="yes"
USE_RUBY="ruby26"

PHP_EXT_NAME="IcePHP"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

PHP_EXT_OPTIONAL_USE=php

USE_PHP="php7-4"

# This variable does not belong to any eclass. It is solely used in this ebuild
BERKDB_SLOTS=( 6.2 6.1 5.3 5.1 4.8 )

inherit db-use mono-env php-ext-source-r3 python-r1 ruby-ng toolchain-funcs

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="https://zeroc.com/products/ice"
SRC_URI="https://github.com/zeroc-ice/ice/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://download.zeroc.com/Ice/$(ver_cut 1-2)/${PN}-3.6.4.pdf )"
LICENSE="GPL-2"
SLOT="0/36"
KEYWORDS="amd64 ~arm x86"
IUSE="debug doc examples +readline mono php python ruby test"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/expat-2.0.1
	>=app-arch/bzip2-1.0.5
	dev-libs/openssl:0=
	virtual/libcrypt:=
	|| (
		$(for slot in ${BERKDB_SLOTS[@]} ; do printf '%s\n' "sys-libs/db:${slot}[cxx]" ; done)
	)
	dev-cpp/libmcpp
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby26) )
	mono? ( dev-lang/mono )"
DEPEND="${RDEPEND}
	readline? ( sys-libs/readline:0= )
	test? (
		${PYTHON_DEPS}
		dev-python/passlib[${PYTHON_USEDEP}]
	)"

# Maintainer notes:
# TODO: java bindings

S="${WORKDIR}/${P,}"
PHP_EXT_S="${S}/php"

PATCHES=(
	"${FILESDIR}/${PN}-3.6.3-no-arch-opts.patch"
	"${FILESDIR}/${P}-db6.patch"
	"${FILESDIR}/${P}-csharp.patch"
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
		-e 's|-L\$\(libdir\)||' \
		cpp/config/Make.rules || die

	sed -i \
		-e 's|-O2 ||g' \
		-e 's|-Werror ||g' \
		cpp/config/Make.rules.Linux || die

	sed -i \
		-e 's|install-common||' \
		{cpp,csharp,php,python,ruby}/Makefile || die

	sed -i \
		-e 's|-f -root|-f -gacdir $(GAC_DIR) -root|' \
		csharp/config/Make.rules.cs || die

	# skip mono tests, bug #498484
	sed -i \
		-e '/SUBDIRS/s|\ test||' \
		csharp/Makefile || die

	# skip udp test due to multicast
	# skip IceGrid/admin bug #649850
	# skip IceSSL tests due to requirement of internet connection
	# skip IceStorm/single bug #636834
	# IceUtil/stacktrace and IceStorm/stress fail with USE=debug
	# Glacier2/staticFiltering requires network access
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=udp --rfilter=IceGrid\/admin --rfilter=IceSSL --rfilter=IceStorm\/single --rfilter=IceStorm\/stress --rfilter=IceUtil\/stacktrace --rfilter=Glacier2\/staticFiltering|' \
		cpp/Makefile || die

	# fails even on unicode locale
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=Slice\/unicodePaths|' \
		ruby/Makefile || die

	# fix for x86 IceBox test
	sed -i \
		-e 's|"32"|""|' \
		scripts/TestUtil.py || die
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
		"prefix=\"${ED}/usr\""
		"install_docdir=\"${ED}/usr/share/doc/${PF}\""
		"install_configdir=\"${ED}/usr/share/${P}/config\""
		"install_mandir=\"${ED}/usr/share/man/man1\""
		"embedded_runpath_prefix=\"${EPREFIX}/usr\""
		"LP64=yes"
		"new_dtags=yes"
		"NOTEST=$(usex !test)"
		"USE_READLINE=$(usex readline)"
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
		cpp/config/Make.rules{,.Linux} python/config/Make.rules || die

	if use python; then
		local S="${S}/python"
		python_copy_sources
	fi

	if use ruby; then
		SITERUBY="$(ruby26 -r rbconfig -e 'print RbConfig::CONFIG["sitelibdir"]')"
		SITERUBYARCH="$(ruby26 -r rbconfig -e 'print RbConfig::CONFIG["sitearchdir"]')"
		MAKE_RULES_RUBY=(
			"install_rubydir=\"${ED}/${SITERUBY}\""
			"install_libdir=\"${ED}/${SITERUBYARCH}\""
		)

		# make it use ruby26 only
		sed -i \
			-e 's|RUBY = ruby|\026|' \
			ruby/config/Make.rules || die
		sed -i \
			-e 's|env ruby|\026|' \
			ruby/config/s2rb.rb || die
		sed -i \
			-e 's|env ruby|\026|' \
			ruby/scripts/slice2rb || die
		sed -i \
			-e 's|output.write("ruby|\026|' \
			scripts/TestUtil.py || die
	fi

	MAKE_RULES_MONO=(
		"GACINSTALL=yes"
		"GAC_ROOT=\"${ED}/usr/$(get_libdir)\""
		"GAC_DIR=\"${EPREFIX}/usr/$(get_libdir)\""
		"install_libdir=\"${ED}/usr/$(get_libdir)\""
		"install_pkgconfigdir=\"${ED}/usr/$(get_libdir)/pkgconfig\""
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
			PYTHONPATH="${BUILD_DIR}"/python emake -C "${BUILD_DIR}" \
				"${MAKE_RULES[@]}" \
				PYTHON="${EPYTHON}" \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" test
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
	use doc && DOCS+=( "${DISTDIR}/${PN}-3.6.4.pdf" )
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

		pushd "${ED}/usr/share/${P}/slice" >/dev/null || die

		local -x LD_LIBRARY_PATH="${ED}/usr/$(get_libdir):${LD_LIBRARY_PATH}"
		for i in *; do
			mkdir -p "${ED}/usr/share/php/${i}" || die
			"${ED}"/usr/bin/slice2php \
				-I"${ED}/usr/share/${P}/slice/" --all \
				--output-dir "${ED}/usr/share/php/${i}" \
				--ice "${ED}/usr/share/${P}/slice/${i}"/*
		done

		for i in $(php_get_slots); do
			php_init_slot_env "${i}"
			insinto "${EXT_DIR}"
			newins "php/lib/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so"
		done
		php-ext-source-r3_createinifiles

		popd >/dev/null || die
	fi

	if use python; then
		installation() {
			mkdir -p "${D}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" \
				"${MAKE_RULES[@]}" \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				install
			python_optimize
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
