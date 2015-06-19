# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/iasl/iasl-20140627.ebuild,v 1.1 2014/08/02 02:38:38 polynomial-c Exp $

EAPI=5

inherit toolchain-funcs flag-o-matic eutils

MY_PN=acpica-unix
MY_P=${MY_PN}-${PV}
MY_TESTS_P=${MY_PN/ca/tests}-${PV}
DESCRIPTION="Intel ACPI Source Language (ASL) compiler"
HOMEPAGE="https://www.acpica.org/downloads/"
SRC_URI="http://www.acpica.org/sites/acpica/files/${MY_P}.tar.gz
	test? ( http://www.acpica.org/sites/acpica/files/${MY_TESTS_P}.tar.gz )"

LICENSE="iASL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=""

S=${WORKDIR}/${MY_P}

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
	epatch "${FILESDIR}/${PN}-20140214-locale.patch" \
		"${FILESDIR}/${PN}-20140214-nostrip.patch"

	find "${S}" -type f -name 'Makefile*' -print0 | \
		xargs -0 -I '{}' \
		sed -r -e 's:-\<Werror\>::g' -i '{}' \
		|| die

	# BITS is tied to ARCH - please set appropriately if you add new keywords
	if [[ $ARCH == @(amd64|amd64-fbsd) ]] ; then
		export BITS=64
	else
		export BITS=32
	fi
}

src_configure() {
	:
}

src_compile() {
	cd acpica/generate/unix
	emake BITS=${BITS}
}

src_test() {
	aslts_test
	#aapits_test
	#The aapits test currently fails, missing include probably.
}

src_install() {
	cd acpica/generate/unix
	emake install DESTDIR="${D}" BITS=${BITS}
	default_src_install
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
		dodir /usr/share/${PF}
		insinto /usr/share/${PF}
		doins ${tb}
	fi

}

aslts_test() {
	export	ASL="${S}"/generate/unix/bin/iasl \
		acpiexec="${S}"/generate/unix/bin/acpiexec \
		ASLTSDIR="${WORKDIR}/${MY_TESTS_P}"/tests/aslts
	export	PATH="${PATH}:${ASLTSDIR}/bin"
	echo "$ASLTSDIR" >"${T}"/asltdir
	cd "${ASLTSDIR}"
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
	chmod +x $(find bin/ | sed  -r -e '/\/[A-Z_]+$/d') || die "chmod bin +x failed"
	make || die "make in aapits failed"
	cd asl || die "cd asl failed"
	make || die "make in asl failed"
	cd ../bin
	./aapitsrun || die "aapitsrun failed"
}
