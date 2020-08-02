# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_PV=$(get_version_component_range 1-3)
DESCRIPTION="Scheme interpreter and native Scheme to C compiler"
HOMEPAGE="http://www.call-cc.org/"
SRC_URI="http://code.call-cc.org/releases/${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="doc"

DEPEND=""
RDEPEND=""

src_prepare() {
	default

	#Because chicken's Upstream is in the habit of using variables that
	#portage also uses :( eg. $ARCH and $A
	sed "s,A\(\s?=\|)\),chicken&," \
		-i Makefile.cross-linux-mingw defaults.make rules.make || die
	sed "s,ARCH,zARCH," \
		-i Makefile.* defaults.make rules.make || die
	sed -e "s,\$(PREFIX)/lib,\$(PREFIX)/$(get_libdir)," \
		-e "s,\$(DATADIR)/doc,\$(SHAREDIR)/doc/${PF}," \
		-i defaults.make || die

	if ! use doc; then
		rm -rf manual || die
		# Without this Makefile tries to re-bootstrap the compiler
		touch build-version.c
	fi
}

src_compile() {
	emake -j1 PLATFORM=linux PREFIX=/usr C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" \
		LINKER_OPTIONS="${LDFLAGS}" \
		HOSTSYSTEM="${CBUILD}"
}

src_test() {
	cd tests
	./runtests.sh || die
}

src_install() {
	# still can't run make in parallel for the install target
	emake -j1 PLATFORM=linux PREFIX=/usr DESTDIR="${D}" HOSTSYSTEM="${CBUILD}" \
		LINKER_OPTIONS="${LDFLAGS}" install

	rm "${D}"/usr/share/doc/${PF}/LICENSE || die

	# README is installed by Makefile
	dodoc NEWS

	# Let portage track this file (created later)
	touch "${D}"/usr/$(get_libdir)/chicken/8/modules.db || die
}

pkg_postinst() {
	# Create modules.db file in ${ROOT}
	chicken-install -update-db || die
}
