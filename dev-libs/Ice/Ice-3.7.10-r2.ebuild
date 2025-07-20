# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

RUBY_OPTIONAL="yes"
USE_RUBY="ruby33"

PHP_EXT_NAME="IcePHP"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

PHP_EXT_OPTIONAL_USE=php

USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-source-r3 python-r1 ruby-ng toolchain-funcs

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="https://zeroc.com/ice"
SRC_URI="https://github.com/zeroc-ice/ice/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://download.zeroc.com/Ice/$(ver_cut 1-2)/${PN}-3.7.1.pdf )"
S="${WORKDIR}/${P,}"
LICENSE="GPL-2"
SLOT="0/37"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="debug doc examples php python ruby test"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=app-arch/bzip2-1.0.5
	>=dev-libs/expat-2.0.1
	dev-libs/libedit
	dev-cpp/libmcpp
	dev-db/lmdb:=
	dev-libs/openssl:0=
	virtual/libcrypt:=
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby33) )"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		dev-python/passlib[${PYTHON_USEDEP}]
	)"

# Maintainer notes:
# TODO: java bindings

PHP_EXT_S="${S}/php"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.8-fix-musl-build.patch"
	"${FILESDIR}/${PN}-3.7.8-python3.13.patch"
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
		-e 's|-Werror ||g' \
		config/Make.rules.Linux || die

	# fix for x86 IceBox test
	sed -i \
		-e 's|"32"|""|' \
		scripts/IceBoxUtil.py || die

	if use !test; then
		# Disable building tests
		sed -i \
			-e 's|include \$(top_srcdir)/config/Make.tests.rules||' \
			config/Make.rules || die
	fi
}

src_configure() {
	MAKE_RULES=(
		"CONFIGS=shared cpp11-shared"
		"embedded_runpath_prefix=\"${EPREFIX}/usr\""
		"OPTIMIZE=$(usex !debug)"
		"V=1"
	)

	if use python; then
		local S="${S}/python"
		python_copy_sources
	fi

	if use ruby; then
		SITERUBY="$(ruby33 -r rbconfig -e 'print RbConfig::CONFIG["sitelibdir"]')"
		SITERUBYARCH="$(ruby33 -r rbconfig -e 'print RbConfig::CONFIG["sitearchdir"]')"
		MAKE_RULES_RUBY=(
			"install_rubydir=\"${EPREFIX}/${SITERUBY}\""
			"install_rubylibdir=\"${EPREFIX}/${SITERUBYARCH}\""
		)

		# make it use ruby33 only
		sed -i \
			-e 's|RUBY ?= ruby|\033|' \
			ruby/config/Make.rules || die
		sed -i \
			-e 's|env ruby|\033|' \
			ruby/config/s2rb.rb || die
		sed -i \
			-e 's|env ruby|\033|' \
			ruby/scripts/slice2rb || die
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

			emake -C php "${MAKE_RULES[@]}" "PHP_CONFIG=\"${EPREFIX}/usr/$(get_libdir)/${i}/bin/php-config\""
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
				install_pythondir="\"$(python_get_sitedir)\"" \
				install_libdir="\"$(python_get_sitedir)\"" test
		}
		local S="${S}/python"
		python_foreach_impl testing
	fi

	if use ruby; then
		emake -C ruby "${MAKE_RULES[@]}" "${MAKE_RULES_RUBY[@]}" test
	fi
}

src_install() {
	local DOCS=( CHANGELOG*.md README.md )
	use doc && DOCS+=( "${DISTDIR}/${PN}-3.7.1.pdf" )
	einstalldocs

	MAKE_RULES_INSTALL=(
		"prefix=\"${ED}/usr\""
		"install_docdir=\"${ED}/usr/share/doc/${PF}\""
		"install_configdir=\"${ED}/usr/share/${P}/config\""
		"install_mandir=\"${ED}/usr/share/man/man1\""
	)

	insinto /usr/share/${P}
	doins -r slice

	emake -C cpp "${MAKE_RULES[@]}" "${MAKE_RULES_INSTALL[@]}" install

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
			newins "php/lib/ice.so" "${PHP_EXT_NAME}.so"
		done
		php-ext-source-r3_createinifiles

		popd >/dev/null || die
	fi

	if use python; then
		installation() {
			mkdir -p "${D}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" \
				"${MAKE_RULES[@]}" \
				"${MAKE_RULES_INSTALL[@]}" \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				install
			python_optimize
		}
		local S="${S}/python"
		python_foreach_impl installation
	fi

	if use ruby; then
		MAKE_RULES_RUBY=(
			"install_rubydir=\"${ED}/${SITERUBY}\""
			"install_rubylibdir=\"${ED}/${SITERUBYARCH}\""
		)
		dodir "${SITERUBY}"
		emake -C ruby "${MAKE_RULES[@]}" "${MAKE_RULES_INSTALL[@]}" "${MAKE_RULES_RUBY[@]}" install
	fi
}
