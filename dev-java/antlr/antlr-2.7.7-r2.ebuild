# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/antlr/antlr-2.7.7-r2.ebuild,v 1.10 2015/03/21 15:08:20 jlec Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"

inherit base java-pkg-2 mono distutils multilib toolchain-funcs versionator

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr2.org/"
SRC_URI="http://www.antlr2.org/download/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd"
IUSE="doc debug examples mono +cxx +java python script source static-libs"

# TODO do we actually need jdk at runtime?
RDEPEND=">=virtual/jdk-1.3
	mono? ( dev-lang/mono )"
DEPEND="${RDEPEND}
	script? ( !dev-util/pccts )
	source? ( app-arch/zip )"

PATCHES=( "${FILESDIR}/2.7.7-gcc-4.3.patch" "${FILESDIR}/2.7.7-gcc-4.4.patch" "${FILESDIR}/2.7.7-makefixes.patch" )

make_shared_lib() {
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	einfo "Making ${soname}"
	${2:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${1}" -Wl,--no-whole-archive \
		-o $(dirname "${1}")/"${soname}" || return 1
}

pkg_setup() {
	java-pkg-2_pkg_setup

	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	base_src_prepare
	sed -i \
		-e 's/install:.*this-install/install:/' \
		lib/cpp/src/Makefile.in || die
}

src_configure() {
	# don't ask why, but this is needed for stuff to get built properly
	# across the various JDKs
	JAVACFLAGS="+ ${JAVACFLAGS}"

	# mcs for https://bugs.gentoo.org/show_bug.cgi?id=172104
	CSHARPC="mcs" econf $(use_enable java) \
		$(use_enable python) \
		$(use_enable mono csharp) \
		$(use_enable debug) \
		$(use_enable examples) \
		$(use_enable cxx) \
		--enable-verbose
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS} -fPIC" || die "compile failed"
	if use cxx; then
		pushd lib/cpp/src > /dev/null
		make_shared_lib libantlr.a || die
		if use static-libs; then
			make clean
			emake || die "compile static failed"
		fi
		popd > /dev/null
	fi
	sed -e "s|@prefix@|/usr/|" \
		-e 's|@exec_prefix@|${prefix}|' \
		-e "s|@libdir@|\$\{exec_prefix\}/$(get_libdir)/antlr|" \
		-e 's|@libs@|-r:\$\{libdir\}/antlr.astframe.dll -r:\$\{libdir\}/antlr.runtime.dll|' \
		-e "s|@VERSION@|${PV}|" \
		"${FILESDIR}"/antlr.pc.in > "${S}"/antlr.pc
}

src_install() {
	dobin "${S}"/scripts/antlr-config

	if use cxx ; then
		cd "${S}"/lib/cpp
		einstall || die "failed to install C++ files"
		dolib.so src/libantlr.so* || die
		dosym libantlr.so.$(get_major_version) /usr/$(get_libdir)/libantlr.so
		use static-libs && dolib.a src/libantlr.a
	fi

	if use java ; then
		java-pkg_dojar "${S}"/antlr/antlr.jar

		use script && java-pkg_dolauncher antlr --main antlr.Tool

		use source && java-pkg_dosrc "${S}"/antlr
		use doc && java-pkg_dohtml -r "${S}"/doc/*
	fi

	if use mono ; then
		cd "${S}"/lib

		dodir /usr/$(get_libdir)/antlr/
		insinto /usr/$(get_libdir)/antlr/

		doins antlr.astframe.dll
		doins antlr.runtime.dll

		insinto /usr/$(get_libdir)/pkgconfig
		doins "${S}"/antlr.pc
	fi

	if use python ; then
		cd "${S}"/lib/python
		distutils_src_install
	fi

	if use examples ; then
		find "${S}"/examples -iname Makefile\* -exec rm \{\} \;

		dodir /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples

		use cxx && doins -r "${S}"/examples/cpp
		use java && doins -r "${S}"/examples/java
		use mono && doins -r "${S}"/examples/csharp
		use python && doins -r "${S}"/examples/python
	fi

	newdoc "${S}"/README.txt README || die
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
