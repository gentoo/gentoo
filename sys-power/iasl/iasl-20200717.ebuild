# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix toolchain-funcs

MY_PN=acpica-unix
MY_P="${MY_PN}-${PV}"
MY_TESTS_P="${MY_PN/ca/tests}-${PV}"

DESCRIPTION="Intel ACPI Source Language (ASL) compiler"
HOMEPAGE="https://www.acpica.org/downloads/"
SRC_URI="
	http://www.acpica.org/sites/acpica/files/${MY_P}.tar.gz
	test? ( http://www.acpica.org/sites/acpica/files/${MY_TESTS_P}.tar.gz )"

LICENSE="iASL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-20200326-Makefile.patch )

pkg_setup() {
	if use test && has test ${FEATURES}; then
		ewarn 'You have selected USE="test". This will install the test results'
		ewarn "into /usr/share/${PF}/, compressed as a tarball."
		ewarn 'The tests themselves will only rarely die, but the test results'
		ewarn 'are interesting for arch testing. The tests may take quite some'
		ewarn 'time to complete.'
	fi
}

src_prepare() {
	default

	find "${S}" -type f -name 'Makefile*' -print0 | \
		xargs -0 -I '{}' \
		sed -r -e 's:-\<Werror\>::g' -e "s:/usr:${EPREFIX}/usr:g" \
		-i '{}' \
		|| die
}

src_configure() {
	tc-export CC

	# BITS is tied to ARCH - please set appropriately if you add new keywords
	if [[ $ARCH == @(amd64) ]] ; then
		export BITS=64
	else
		export BITS=32
	fi
}

src_compile() {
	emake -C generate/unix BITS="${BITS}"
}

src_test() {
	aslts_test
	#The aapits test currently fails, missing include probably.
	#aapits_test
}

src_install() {
	cd generate/unix || die
	emake install DESTDIR="${D}" BITS=${BITS}
	default
	#local bin
	#for bin in $(<"${T}"/binlist) ; do
	#	dobin "${T}"/${bin}
	#done
	dodoc "${S}"/changes.txt
	newdoc "${S}"/source/compiler/readme.txt compiler-readme.txt
	newdoc "${S}"/generate/unix/readme.txt unix-readme.txt
	newdoc "${S}"/generate/lint/readme.txt lint-readme.txt
	newdoc "${S}"/source/compiler/new_table.txt compiler-new_table.txt

	if use test && has test ${FEATURES}; then
		tb="${T}"/testresults.tar.bz2
		export ASLTSDIR="$(<"${T}"/asltdir)"
		ebegin "Creating Test Tarball"
		tar -cjf "${tb}" -C "${ASLTSDIR}"/tmp/RESULTS .  || die "tar failed"
		eend $?
		insinto /usr/share/${PF}
		doins ${tb}
	fi
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
	make install || die "make install aslts test failed"
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
	make || die "make in aapits failed"
	cd asl || die "cd asl failed"
	make || die "make in asl failed"
	cd ../bin || die
	./aapitsrun || die "aapitsrun failed"
}
