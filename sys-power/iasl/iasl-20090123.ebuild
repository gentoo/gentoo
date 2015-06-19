# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/iasl/iasl-20090123.ebuild,v 1.9 2014/03/26 14:16:40 polynomial-c Exp $

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
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
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

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/iasl-20080701-parallelmake.patch

	sed -i -e 's:LDFLAGS=:LDLIBS+=:' \
		"${S}"/compiler/Makefile || die "unable to fix compiler Makefile"
}

src_compile() {
	local target bin
	append-flags -fno-strict-aliasing

	for target in compiler tools/acpisrc tools/acpixtract tools/acpiexec
	do
		einfo "Compiling in ${target}/"
		cd "${S}"/${target}
		case "${target}" in
			compiler) bin=iasl;;
			*) bin=${target#*/};;
		esac

		emake CC="$(tc-getCC)" || die "emake in ${target} failed"
		einfo "Finished compiling ${target}"

		mv ${bin} "${T}" || die "mv ${bin} failed"
		einfo "Finished moving ${bin}"

		make clean || die "make clean in ${target} failed"
		einfo "Finished cleaning ${target}"

		echo ${bin} >>"${T}"/binlist
	done
	einfo "$(<"${T}"/binlist)"
}

src_test() {
	aslts_test
	#aapits_test
	#The aapits test currently fails, missing include probably.
}

src_install() {
	local bin
	for bin in $(<"${T}"/binlist) ; do
		dobin "${T}"/${bin}
	done
	dodoc README changes.txt
	if use test && has test ${FEATURES}; then
		tb="${T}"/testresults.tar.bz2
		export ASLTSDIR="$(<"${T}"/asltdir)"
		ebegin "Creating Test Tarball"
		tar -cjf "${tb}" -C "${ASLTSDIR}"/tmp/RESULTS .  || die "tar failed"
		eend $?
		dodir /usr/share/${PF}
		insinto /usr/share/${PF}
		doins ${tb} || die "doins testresults.tar.bz2 failed"
	fi

}

aslts_test() {
	export	ASL="${T}"/iasl \
		acpiexec="${T}"/acpiexec \
		ASLTSDIR="${WORKDIR}/${MY_TESTS_P}"/tests/aslts
	export	PATH="${PATH}:${ASLTSDIR}/bin"
	echo "$ASLTSDIR" >"${T}"/asltdir
	cd "${ASLTSDIR}"
	edos2unix $(find . -type 'f')
	make install || die "make install aslts test failed"
	chmod +x $(find bin/ | sed  -r -e '/\/[A-Z_]+$/d') || die "chmod bin +x failed"

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
