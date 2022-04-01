# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Scheme interpreter and native Scheme to C compiler"
HOMEPAGE="https://www.call-cc.org/"
SRC_URI="https://code.call-cc.org/releases/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc ppc64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

src_prepare() {
	default

	# because chicken's upstream is in the habit of using variables that
	# portage also uses :( eg. $ARCH and $A
	sed -i \
		-e "s/A\([[:space:]]*?=\|)\)/z&/" \
		-e "s/ARCH/z&/" \
		-e "/LICENSE /d" \
		Makefile.* {defaults,rules}.make || die
	sed -i \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|\$(DATADIR)/doc|\$(SHAREDIR)/doc/${PF}|" \
		defaults.make || die
	sed -i \
		-e "/\$(CHICKEN_DO_PROGRAM)\$(EXE):/,/^$/s/\(\$<\)/\$(LINKER_OPTIONS) \1/" \
		rules.make || die

	use doc || sed -i "/\$(SEP)manual/d" rules.make || die
}

src_compile() {
	emake -j1 \
		PLATFORM="linux" \
		PREFIX="${EPREFIX}/usr" \
		C_COMPILER="$(tc-getCC)" \
		C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" \
		CXX_COMPILER="$(tc-getCXX)" \
		HOSTSYSTEM="${CBUILD}" \
		LINKER_OPTIONS="${LDFLAGS}"
}

src_test() {
	cd tests && ./runtests.sh || die
}

src_install() {
	emake -j1 \
		PLATFORM="linux" \
		PREFIX="${EPREFIX}/usr" \
		C_COMPILER="$(tc-getCC)" \
		C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" \
		CXX_COMPILER="$(tc-getCXX)" \
		HOSTSYSTEM="${CBUILD}" \
		LINKER_OPTIONS="${LDFLAGS}" \
		DESTDIR="${D}" \
		install
	einstalldocs
	find "${ED}" -name '*.a' -delete || die

	# let portage track this file (created later)
	touch "${ED}"/usr/$(get_libdir)/${PN}/11/modules.db || die
}

pkg_postinst() {
	# create modules.db file in ${ROOT}
	chicken-install -update-db || die
}
