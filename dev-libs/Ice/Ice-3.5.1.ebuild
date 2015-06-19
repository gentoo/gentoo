# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/Ice/Ice-3.5.1.ebuild,v 1.11 2015/04/08 17:51:56 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )
RUBY_OPTIONAL="yes"
USE_RUBY="ruby19"

inherit toolchain-funcs versionator python-r1 mono-env ruby-ng db-use

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="http://www.zeroc.com/"
SRC_URI="http://www.zeroc.com/download/Ice/$(get_version_component_range 1-2)/${P}.tar.gz
	doc? ( http://www.zeroc.com/download/Ice/$(get_version_component_range 1-2)/${P}.pdf )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86 ~x86-linux ~x64-macos"
IUSE="doc examples +ncurses mono python ruby test debug"

RDEPEND=">=dev-libs/expat-2.0.1
	>=app-arch/bzip2-1.0.5
	>=dev-libs/openssl-0.9.8o:0
	|| (
		sys-libs/db:5.3[cxx]
		sys-libs/db:5.1[cxx]
		sys-libs/db:4.8[cxx]
	)
	~dev-cpp/libmcpp-2.7.2
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby19) )
	mono? ( dev-lang/mono )
	!dev-python/IcePy
	!dev-ruby/IceRuby"
DEPEND="${RDEPEND}
	ncurses? ( sys-libs/ncurses sys-libs/readline )
	test? ( ${PYTHON_DEPS} )"

# Maintainer notes:
# - yes, we have to do the trickery with the move for the python functions
#   since the build and test frameworks deduce various settings from the path
#   and they can't be tricked by a symlink. And we also need
#   SUPPORT_PYTHON_ABIS=1 otherwise we can't get pyc/pyo anymore the sane way.
# TODO: php bindings
# TODO: java bindings

#overwrite ruby-ng.eclass default
S="${WORKDIR}/${P}"

pkg_setup() {
	# prevent ruby-ng.eclass from messing with src_unpack
	:;
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	sed -i \
		-e 's|\(install_docdir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_configdir[[:space:]]*\):=|\1?=|' \
		cpp/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|\(install_pythondir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_rubydir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_libdir[[:space:]]*\):=|\1?=|' \
		{py,rb}/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|-O2 ||g' \
		-e 's|-Werror ||g' \
		cpp/config/Make.rules.Linux || die "sed failed"

	sed -i \
		-e 's|install-common||' \
		-e 's|demo||' \
		{cpp,cs,php,py,rb}/Makefile || die "sed failed"

	sed -i \
		-e 's|-f -root|-f -gacdir $(GAC_DIR) -root|' \
		cs/config/Make.rules.cs || die "sed failed"

	# skip mono tests, bug #498484
	sed -i \
		-e 's|^\(SUBDIRS.*\)test|\1|' \
		cs/Makefile || die "sed failed"

	if ! use test ; then
		sed -i \
			-e 's|^\(SUBDIRS.*\)test|\1|' \
			{cpp,php,py,rb}/Makefile || die "sed failed"
	fi
}

suitable_db_version() {
	local tested_slots="5.3 5.1 4.8"
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
		install_configdir=\"${ED}/usr/share/Ice-${PV}/config\"
		install_mandir=\"${ED}/usr/share/man\"
		embedded_runpath_prefix=\"${EPREFIX}/usr\"
		LP64=yes"

	use ncurses && OPTIONS="${MAKE_RULES} USE_READLINE=yes" || MAKE_RULES="${MAKE_RULES} USE_READLINE=no"
	use debug && OPTIONS"${MAKE_RULES} OPTIMIZE=no" || MAKE_RULES="${MAKE_RULES} OPTIMIZE=yes"

	local BERKDB_VERSION="$(suitable_db_version)"
	MAKE_RULES="${MAKE_RULES} DB_FLAGS=-I$(db_includedir ${BERKDB_VERSION})"
	sed -i \
		-e "s|g++|$(tc-getCXX)|" \
		-e "s|\(CFLAGS[[:space:]]*=\)|\1 ${CFLAGS}|" \
		-e "s|\(CXXFLAGS[[:space:]]*=\)|\1 ${CXXFLAGS}|" \
		-e "s|\(LDFLAGS[[:space:]]*=\)|\1 ${LDFLAGS}|" \
		-e "s|\(DB_LIBS[[:space:]]*=\) \-ldb_cxx|\1 -ldb_cxx-$(db_findver sys-libs/db:${BERKDB_VERSION})|" \
		cpp/config/Make.rules{,.Linux} py/config/Make.rules || die "sed failed"

	if use python ; then
		S=${S}/py python_copy_sources

		# make a place for the symlink
		rm -r py/python || die
	fi

	if use ruby ; then
		SITERUBY="$(ruby19 -r rbconfig -e 'print Config::CONFIG["sitedir"]')"
		MAKE_RULES_RB="install_rubydir=\"${ED}/${SITERUBY}\"
			install_libdir=\"${ED}/${SITERUBY}\""

		# make it use ruby19 only
		sed -i \
			-e 's|RUBY = ruby|\019|' \
			rb/config/Make.rules || die "sed failed"
	fi

	MAKE_RULES_CS="GACINSTALL=yes GAC_ROOT=\"${ED}/usr/$(get_libdir)\" GAC_DIR=${EPREFIX}/usr/$(get_libdir)"

	use test && python_export_best
}

src_compile() {
	# Do not remove this export or build will break!
	tc-export CXX

	emake -C cpp ${MAKE_RULES} || die "emake failed"

	if use doc ; then
		emake -C cpp/doc || die "building docs failed"
	fi

	if use python ; then
		building() {
			emake -C "${BUILD_DIR}" ${MAKE_RULES} || die "emake py-${EPYTHON} failed"
		}
		BUILD_DIR=py python_foreach_impl building
	fi

	if use ruby ; then
		emake -C rb ${MAKE_RULES} ${MAKE_RULES_RB} || die "emake rb failed"
	fi

	if use mono ; then
		emake -C cs ${MAKE_RULES} ${MAKE_RULES_CS} || die "emake cs failed"
	fi
}

src_install() {
	dodoc CHANGES README

	insinto /usr/share/${P}
	doins -r slice

	emake -C cpp ${MAKE_RULES} install || die "emake install failed"

	docinto cpp
	dodoc CHANGES README

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples-cpp
		doins cpp/config/*.cfg
		doins -r cpp/demo/*
	fi

	if use doc ; then
		dohtml -r cpp/doc/reference/*
		dodoc "${DISTDIR}/${P}.pdf"
	fi

	if use python ; then
		installation() {
			mkdir -p "${D}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" ${MAKE_RULES} \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				install || die "emake py-${EPYTHON} install failed"
		}
		BUILD_DIR=py python_foreach_impl installation

		docinto py
		dodoc py/CHANGES py/README

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-py
			doins -r py/demo/*
		fi
	fi

	if use ruby ; then
		dodir "${SITERUBY}"
		emake -C rb ${MAKE_RULES} ${MAKE_RULES_RB} install || die "emake rb install failed"

		docinto rb
		dodoc rb/CHANGES rb/README

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-rb
			doins -r rb/demo/*
		fi
	fi

	if use mono ; then
		emake -C cs ${MAKE_RULES} ${MAKE_RULES_CS} install || die "emake cs install failed"

		# TODO: anyone has an idea what those are for?
		rm "${ED}"/usr/bin/*.xml

		docinto cs
		dodoc cs/CHANGES cs/README

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-cs
			doins -r cs/demo/*
		fi
	fi
}

run_tests() {
	# Run tests through the script interface since Python test runner
	# fails to exit with non-zero code for some reason.

	pushd "${1}" >/dev/null || die
	./allTests.py --script | sh
	ret=${?}
	popd >/dev/null || die

	return ${ret}
}

src_test() {
	run_tests cpp || die "emake cpp test failed"

	if use python ; then
		testing() {
			# tests require that the directory is named 'py'
			ln -f -s ../"${BUILD_DIR}"/python py/python || die
			run_tests py || die "emake py-${EPYTHON} test failed"
		}
		BUILD_DIR=py python_foreach_impl testing
	fi

	if use ruby ; then
		run_tests rb || die "emake rb test failed"
	fi

	if use mono ; then
		# skip mono tests, bug #498484
		ewarn "Tests for C# are currently disabled."
#		run_tests cs || die "emake cs test failed"
	fi
}
