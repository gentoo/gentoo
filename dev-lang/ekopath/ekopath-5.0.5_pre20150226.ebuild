# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ekopath/ekopath-5.0.5_pre20150226.ebuild,v 1.2 2015/04/02 18:35:06 mr_bones_ Exp $

EAPI=5

inherit versionator multilib pax-utils

MY_PV=$(get_version_component_range 1-3)
DATE=$(get_version_component_range 4)
DATE=${DATE/pre}
DATE=${DATE:0:4}-${DATE:4:2}-${DATE:6}

DESCRIPTION="PathScale EKOPath Compiler Suite"
HOMEPAGE="http://www.pathscale.com/ekopath-compiler-suite"
SRC_URI="http://c591116.r16.cf2.rackcdn.com/${PN}/nightly/Linux/${PN}-${DATE}-installer.run
	-> ${P}.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!!app-arch/rpm"
RDEPEND=""

RESTRICT="mirror"

QA_PREBUILT="
	opt/${PN}/lib/${MY_PV}/x8664/*
	opt/${PN}/bin/*"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}" || die
	chmod +x "${S}"/${P}.run
}

src_prepare() {
	cat > 99${PN} <<-EOF
		PATH=${EROOT%/}/opt/${PN}/bin
		ROOTPATH=${EROOT%/}/opt/${PN}/bin
		LDPATH=${EROOT%/}/opt/${PN}/lib:${EROOT%/}/opt/${PN}/lib/${MY_PV}/x8664/64
		MANPATH=${EROOT%/}/opt/${PN}/docs/man
	EOF
}

src_install() {
	# sad stuff bug #511016
#	local libdir
#	for libdir in $(get_all_libdirs); do
#		addpredict /${libdir}/libpthread.so.0
#		addpredict /${libdir}/libc.so.6
#		addpredict /${libdir}/ld-linux-x86-64.so.2
#		addpredict /usr/${libdir}/libpthread.a
#		addpredict /usr/${libdir}/libc.a
#		addpredict /usr/${libdir}/libpthread_nonshared.a
#		addpredict /usr/${libdir}/libc_nonshared.a
#		addpredict /usr/${libdir}/libdl.a
#		addpredict /usr/${libdir}/libm.a
#		addpredict /usr/${libdir}/libdl.so
#		addpredict /usr/${libdir}/libm.so
#		addpredict /usr/${libdir}/crti.o
#		addpredict /usr/${libdir}/crt1.o
#		addpredict /usr/${libdir}/crtn.o
#	done

	# EI_PAX marking is obsolete and PT_PAX breaks the binary.
	# We must use XT_PAX to run the installer.
	if [[ ${PAX_MARKINGS} == "XT" ]]; then
		pax-mark m ${P}.run
	fi

	./${P}.run \
		--prefix "${ED%/}/opt/${PN}" \
		--mode unattended || die

	# This is a temporary/partial fix to remove a RWX GNU STACK header
	# from libstl.so.  It still leaves libstl.a in bad shape.
	# The correct fix is in the assembly atomic-cxx.S, which we don't get
	#   See http://www.gentoo.org/proj/en/hardened/gnu-stack.xml
	#   Section 6.  How to fix the stack (in practice)
#	scanelf -Xe "${ED}/opt/ekopath/lib/${MY_PV}/x8664/64/libstl.so"

	rm -r "${ED}"/opt/${PN}/uninstall || die
	doenvd 99${PN}
}
