# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix toolchain-funcs

MY_PN=acpica-unix
MY_P="${MY_PN}-${PV}"
MY_TESTS_P="${MY_PN/ca/tests}-${PV}"
REL_TAG="R${PV:0:4}_${PV:4:2}_${PV:6:2}"

DESCRIPTION="Intel ACPI Source Language (ASL) compiler"
HOMEPAGE="https://www.acpica.org/downloads/"
SRC_URI="
	https://github.com/acpica/acpica/releases/download/${REL_TAG}/${MY_P}.tar.gz
	test? ( https://github.com/acpica/acpica/releases/download/${REL_TAG}/${MY_TESTS_P}.tar.gz )"
S="${WORKDIR}/${MY_P}"

LICENSE="iASL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile-fixes.patch
	"${FILESDIR}"/${P}-Makefile-verbose.patch
)

pkg_setup() {
	if use test; then
		ewarn 'You have selected USE="test". This will install the test results'
		ewarn "into /usr/share/${PF}/, compressed as a tarball."
		ewarn 'The tests themselves will only rarely die, but the test results'
		ewarn 'are interesting for arch testing. The tests may take quite some'
		ewarn 'time to complete.'
	fi
}

src_compile() {
	emake -C generate/unix \
	  CC="$(tc-getCC)" \
	  'YACC=LC_ALL=C yacc' \
	  'YFLAGS=' \
	  'LEX=LC_ALL=C lex' \
	  NOFORTIFY=TRUE \
	  NOWERROR=TRUE
}

aslts_test() {
	export ASL="${S}"/generate/unix/bin/iasl \
		acpibin="${S}"/generate/unix/bin/acpibin \
		acpiexec="${S}"/generate/unix/bin/acpiexec \
		ASLTSDIR="${WORKDIR}/${MY_TESTS_P}"/tests/aslts
	export	PATH="${PATH}:${ASLTSDIR}/bin"
	echo "$ASLTSDIR" >"${T}"/asltdir
	cd "${ASLTSDIR}" || die
	edos2unix $(find . -type 'f')
	emake install
	chmod +x $(find bin/ ! -regex 'ERROR_OPCODES|HOW_TO_USE|README' ) || die "chmod bin +x failed"

	#The below Do commands runs the tests twice and then dies if the results aren't
	#Identical.
	Do 1 || die "failed Do 1"
	Do 2 || die "failed Do 2"
}

aapits_test() {
	mv "${WORKDIR}/${MY_TESTS_P}/tests/aapits" "${S}/tools/" || die "mv failed"
	cd "${S}/tools/aapits" || die "cannot find ${S}/tools/aapits"
	edos2unix $(find . -type 'f')
	chmod +x $(find bin/ | sed	-r -e '/\/[A-Z_]+$/d') || die "chmod bin +x failed"
	emake
	emake -C asl
	cd ../bin || die
	./aapitsrun || die "aapitsrun failed"
}

src_test() {
	aslts_test
	#The aapits test currently fails, missing include probably.
	#aapits_test
}

src_install() {
	emake -C generate/unix install DESTDIR="${D}"

	if ! use examples; then
		rm "${ED}/usr/bin/acpiexamples" || die
	fi

	dodoc "${S}"/changes.txt
	newdoc "${S}"/source/compiler/readme.txt compiler-readme.txt
	newdoc "${S}"/generate/unix/readme.txt unix-readme.txt
	newdoc "${S}"/generate/lint/readme.txt lint-readme.txt
	newdoc "${S}"/source/compiler/new_table.txt compiler-new_table.txt

	if use test; then
		tb="${T}"/testresults.tar.bz2
		export ASLTSDIR="$(<"${T}"/asltdir)"
		ebegin "Creating Test Tarball"
		tar -cjf "${tb}" -C "${ASLTSDIR}"/tmp/RESULTS .  || die "tar failed"
		eend $?
		insinto /usr/share/${PF}
		doins ${tb}
	fi
}
