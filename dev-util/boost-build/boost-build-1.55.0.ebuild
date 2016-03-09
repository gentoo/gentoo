# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="python? 2"

RESTRICT="test"

inherit eutils flag-o-matic multilib python toolchain-funcs versionator

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="http://www.boost.org/doc/tools/build/index.html"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT=0
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples python test"

REQUIRED_USE="test? ( python )"

RDEPEND="!<dev-libs/boost-1.34.0
	!<=dev-util/boost-build-1.35.0-r1"
DEPEND="${RDEPEND}
	test? ( sys-apps/diffutils )"

S="${WORKDIR}/boost_${MY_PV}/tools/build/v2"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_unpack() {
	tar xjpf "${DISTDIR}/${A}" boost_${MY_PV}/tools/build/v2 || die "unpacking tar failed"
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-1.48.0-disable_python_rpath.patch" \
		"${FILESDIR}/${PN}-1.50.0-respect-c_ld-flags.patch" \
		"${FILESDIR}/${PN}-1.49.0-darwin-gentoo-toolchain.patch" \
		"${FILESDIR}/${PN}-1.52.0-darwin-no-python-framework.patch" \
		"${FILESDIR}/${PN}-1.54.0-fix-test.patch" \
		"${FILESDIR}/${PN}-1.54.0-support_dots_in_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.55.0-ppc-aix.patch"

	# Remove stripping option
	# Fix python components build on multilib systems, bug #496446
	cd "${S}/engine"
	sed -i \
		-e 's|-s\b||' \
		-e "/libpython/s/lib ]/$(get_libdir) ]/" \
		build.jam || die "sed failed"

	# Force regeneration
	rm jambase.c || die

	# This patch allows us to fully control optimization
	# and stripping flags when bjam is used as build-system
	# We simply extend the optimization and debug-symbols feature
	# with empty dummies called 'none'
	cd "${S}"
	sed -i \
		-e 's/\(off speed space\)/\1 none/' \
		-e 's/\(debug-symbols      : on off\)/\1 none/' \
		tools/builtin.jam || die "sed failed"
}

src_configure() {
	if use python; then
		# replace versions by user-selected one (TODO: fix this when slot-op
		# deps are available to always match the best version available)
		sed -i \
			-e "s|2.7 2.6 2.5 2.4 2.3 2.2|${PYTHON_ABI}|" \
			engine/build.jam || die "sed failed"
	fi
}

src_compile() {
	cd engine

	local toolset

	if [[ ${CHOST} == *-darwin* ]]; then
		toolset=darwin
	else
		# Using boost's generic toolset here, which respects CC and CFLAGS
		toolset=cc
	fi

	CC=$(tc-getCC) ./build.sh ${toolset} -d+2 $(use_with python python "${EROOT}"/usr) || die "building bjam failed"
}

src_install() {
	dobin engine/bin.*/{bjam,b2}

	insinto /usr/share/boost-build
	doins -r "${FILESDIR}/site-config.jam" \
		boost-build.jam bootstrap.jam build-system.jam user-config.jam *.py \
		build kernel options tools util

	rm "${ED}/usr/share/boost-build/build/project.ann.py" || die "removing faulty python file failed"
	if ! use python; then
		find "${ED}/usr/share/boost-build" -iname "*.py" -delete || die "removing experimental python files failed"
	fi

	dodoc changes.txt hacking.txt release_procedure.txt \
		notes/build_dir_option.txt notes/relative_source_paths.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r example
	fi
}

src_test() {
	cd test

	export TMP="${T}"

	DO_DIFF="${PREFIX}/usr/bin/diff" $(PYTHON -2) test_all.py

	if [[ -s test_results.txt ]]; then
		eerror "At least one test failed: $(<test_results.txt)"
		die "tests failed"
	fi
}

pkg_postinst() {
	use python && python_mod_optimize /usr/share/boost-build
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/share/boost-build
}
