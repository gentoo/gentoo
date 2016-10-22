# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

RUBY_OPTIONAL="yes"
USE_RUBY="ruby22"

PHP_EXT_NAME="IcePHP"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

PHP_EXT_OPTIONAL_USE=php

USE_PHP="php7-0"

inherit toolchain-funcs versionator php-ext-source-r2 python-r1 mono-env ruby-ng db-use

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="http://www.zeroc.com/"
SRC_URI="https://github.com/zeroc-ice/ice/archive/v${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://download.zeroc.com/Ice/$(get_version_component_range 1-2)/${P}.pdf )"
LICENSE="GPL-2"
SLOT="0/36"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples libressl +ncurses mono php python ruby test debug"

RDEPEND=">=dev-libs/expat-2.0.1
	>=app-arch/bzip2-1.0.5
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	|| (
		sys-libs/db:5.3[cxx]
		sys-libs/db:5.1[cxx]
	)
	dev-cpp/libmcpp
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby22) )
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

pkg_setup() {
	# prevent ruby-ng.eclass from messing with pkg_setup
	:;
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	epatch "${FILESDIR}/${P}-no-arch-opts.patch"
	epatch "${FILESDIR}/${P}-csharp.patch"
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

	# IceUtil/stacktrace fails with USE=debug
	# skip udp test due to multicast
	# skip IceSSL tests due to requirement of internet connection
	# IceStorm/stress fails without USE=debug
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=IceUtil\/stacktrace --rfilter=udp --rfilter=IceSSL --rfilter=IceStorm\/stress|' \
		cpp/Makefile || die "sed failed"

	# mainly broken .ice files
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=operations --rfilter=slicing\/objects|' \
		python/Makefile || die "sed failed"

	# fails even on unicode locale
	sed -i \
		-e 's|allTests.py|allTests.py --rfilter=Slice\/unicodePaths|' \
		ruby/Makefile || die "sed failed"
}

suitable_db_version() {
	local tested_slots="5.3 5.1"
	for ver in ${tested_slots}; do
		if [[ -n $(db_findver sys-libs/db:${ver}) ]]; then
			echo ${ver}
			return 0
		fi
	done
	die "No suitable BerkDB versions found, aborting"
}

src_configure() {
	MAKE_RULES="prefix=\"${ED}/usr\"
		install_docdir=\"${ED}/usr/share/doc/${PF}\"
		install_configdir=\"${ED}/usr/share/${P}/config\"
		install_mandir=\"${ED}/usr/share/man\"
		embedded_runpath_prefix=\"${EPREFIX}/usr\"
		LP64=yes
		new_dtags=yes
		NOTEST=$(usex test no yes)"

	use ncurses && OPTIONS="${MAKE_RULES} USE_READLINE=yes" || MAKE_RULES="${MAKE_RULES} USE_READLINE=no"
	use debug && OPTIONS="${MAKE_RULES} OPTIMIZE=no" || MAKE_RULES="${MAKE_RULES} OPTIMIZE=yes"

	local BERKDB_VERSION="$(suitable_db_version)"
	MAKE_RULES="${MAKE_RULES} DB_FLAGS=-I$(db_includedir ${BERKDB_VERSION})"
	sed -i \
		-e "s|g++|$(tc-getCXX)|" \
		-e "s|\(CFLAGS[[:space:]]*=\)|\1 ${CFLAGS}|" \
		-e "s|\(CXXFLAGS[[:space:]]*=\)|\1 ${CXXFLAGS}|" \
		-e "s|\(LDFLAGS[[:space:]]*=\)|\1 ${LDFLAGS}|" \
		-e "s|\(DB_LIBS[[:space:]]*=\) \-ldb_cxx|\1 -ldb_cxx-$(db_findver sys-libs/db:${BERKDB_VERSION})|" \
		cpp/config/Make.rules{,.Linux} python/config/Make.rules || die "sed failed"

	if use python ; then
		S=${S}/python python_copy_sources
	fi

	if use ruby ; then
		SITERUBY="$(ruby22 -r rbconfig -e 'print RbConfig::CONFIG["sitelibdir"]')"
		MAKE_RULES_RB="install_rubydir=\"${ED}/${SITERUBY}\"
			install_libdir=\"${ED}/${SITERUBY}\""

		# make it use ruby22 only
		sed -i \
			-e 's|RUBY = ruby|\022|' \
			ruby/config/Make.rules || die "sed failed"
		sed -i \
			-e 's|env ruby|\022|' \
			ruby/config/s2rb.rb || die "sed failed"
		sed -i \
			-e 's|env ruby|\022|' \
			ruby/scripts/slice2rb || die "sed failed"
		sed -i \
			-e 's|output.write("ruby|\022|' \
			scripts/TestUtil.py || die "sed failed"
	fi

	MAKE_RULES_CS="GACINSTALL=yes GAC_ROOT=\"${ED}/usr/$(get_libdir)\" GAC_DIR=${EPREFIX}/usr/$(get_libdir)
		install_libdir=\"${ED}/usr/$(get_libdir)\"
		install_pkgconfigdir=\"${ED}/usr/$(get_libdir)/pkgconfig\""
	if has_version ">dev-lang/mono-4"; then
		MAKE_RULES_CS="${MAKE_RULES_CS} MCS=mcs"
	fi

	use test && python_setup
}

src_compile() {
	# Do not remove this export or build will break!
	tc-export CXX

	emake -C cpp ${MAKE_RULES} || die "emake failed"

	if use php; then
		local slot
		for slot in $(php_get_slots); do
			mkdir -p "${WORKDIR}/${slot}"
			cp -r "${PHP_EXT_S}" "${WORKDIR}/${slot}/" || die "Failed to copy source ${PHP_EXT_S} to PHP target directory"
			cd "${WORKDIR}/${slot}"
			ln -s "${S}/cpp"
			ln -s "${S}/config"
			ln -s "${S}/slice"
			ln -s "${S}/Makefile"

			emake -C php ${MAKE_RULES} USE_NAMESPACES=yes PHP_CONFIG="${EPREFIX}/usr/$(get_libdir)/${slot}/bin/php-config" || die "emake php failed"
		done
		cd "${S}"
	fi

	if use python ; then
		building() {
			emake -C "${BUILD_DIR}" ${MAKE_RULES} PYTHON=${EPYTHON} || die "emake python-${EPYTHON} failed"
		}
		S=${S}/python python_foreach_impl building
	fi

	if use ruby ; then
		emake -C ruby ${MAKE_RULES} ${MAKE_RULES_RB} || die "emake rb failed"
	fi

	if use mono ; then
		emake -C csharp ${MAKE_RULES} ${MAKE_RULES_CS} || die "emake csharp failed"
	fi
}

src_test() {
	export LD_LIBRARY_PATH="${S}/cpp/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake -C cpp ${MAKE_RULES} test || die "emake cpp test failed"

	# php tests require the extension loaded and are therefore skipped

	if use python ; then
		testing() {
			emake -C "${BUILD_DIR}" ${MAKE_RULES} PYTHON=${EPYTHON} \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				test || die "emake python-${EPYTHON} test failed"
		}
		S=${S}/python python_foreach_impl testing
	fi

	if use ruby ; then
		emake -C ruby ${MAKE_RULES} ${MAKE_RULES_RB} test || die "emake ruby test failed"
	fi

	if use mono ; then
		# skip mono tests, bug #498484
		ewarn "Tests for C# are currently disabled."
#		emake -C csharp ${MAKE_RULES} ${MAKE_RULES_CS} test || die "emake csharp test failed"
	fi
}

src_install() {
	dodoc CHANGELOG*.md README.md

	insinto /usr/share/${P}
	doins -r slice

	emake -C cpp ${MAKE_RULES} install || die "emake install failed"

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples-cpp
		doins cpp/config/*.cfg
	fi

	if use doc ; then
		dodoc "${DISTDIR}/${P}.pdf"
	fi

	if use php ; then
		insinto "/usr/share/php/${PN}"
		doins $(cd php/lib; find "${S}"/php/lib/ -name '*.php' -print)
		for dir in $( cd "${D}/usr/share/${P}/slice" ; ls -1 ); do
			mkdir -p "${D}/usr/share/php/${dir}"
			LD_LIBRARY_PATH="${D}/usr/$(get_libdir):${LD_LIBRARY_PATH}" ${D}/usr/bin/slice2php -I${D}/usr/share/${P}/slice/ --all --output-dir ${D}/usr/share/php/${dir} --ice ${D}/usr/share/${P}/slice/${dir}/*
		done

		local slot
		for slot in $(php_get_slots); do
			php_init_slot_env ${slot}
			insinto "${EXT_DIR}"
			newins "php/lib/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so" || die "Unable to install extension"
		done
		php-ext-source-r2_createinifiles

		cd "${S}"
	fi

	if use python ; then
		installation() {
			mkdir -p "${D}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" ${MAKE_RULES} \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				install || die "emake python-${EPYTHON} install failed"
		}
		S=${S}/python python_foreach_impl installation
	fi

	if use ruby ; then
		dodir "${SITERUBY}"
		emake -C ruby ${MAKE_RULES} ${MAKE_RULES_RB} install || die "emake ruyb install failed"
	fi

	if use mono ; then
		emake -C csharp ${MAKE_RULES} ${MAKE_RULES_CS} install || die "emake csharp install failed"
	fi
}
