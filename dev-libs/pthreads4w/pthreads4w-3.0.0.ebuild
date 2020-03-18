# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="POSIX Threads for Windows"
HOMEPAGE="http://pthreads4w.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-code-v${PV}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86-winnt"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	app-arch/unzip
	sys-devel/parity
"

S=${WORKDIR}/${PN}-code-07053a521b0a9deb6db2a649cde1f828f2eb1f4f

src_compile() {
	# from pthreads.h:
	# Note: Unless the build explicitly defines one of the following, then
	# we default to standard C style cleanup. This style uses setjmp/longjmp
	# in the cancellation and thread exit implementations and therefore won't
	# do stack unwinding if linked to applications that have it (e.g.
	# C++ apps). This is currently consistent with most/all commercial Unix
	# POSIX threads implementations.
	local variant="VC" # C style cleanup

	case ${CHOST} in
	*-libcmtd*) variant+="-static-debug" ;;
	*-libcmt*) variant+="-static" ;;
	*-msvcd*) variant+="-debug" ;;
	*-msvc*) ;;
	esac

	case ${CHOST} in
	x86_64-*) variant+=" TARGET_CPU=x64" ;;
	i?86-*) variant+=" TARGET_CPU=x86" ;;
	esac

	${CHOST}-nmake -f Makefile ${variant} || die
}

src_install() {
	local V=$(ver_cut 1)
	case ${CHOST} in
	*-libcmtd*|*-msvcd*) V+="d" ;; # debug CRT
	esac
	case ${CHOST} in
	*-libcmt*) # static CRT
		dolib.so libpthreadVC${V}.lib
		newlib.so libpthreadVC${V}.lib libpthread.lib # for -lpthread
		;;
	*-msvc*) # dynamic CRT
		dobin pthreadVC${V}.dll
		dolib.so pthreadVC${V}.lib
		newlib.so pthreadVC${V}.lib pthread.lib # for -lpthread
		;;
	esac
	insinto /usr/include
	doins {pthread,sched,semaphore,_ptw32}.h
	einstalldocs
}

src_test() {
	${CHOST}-nmake -DEXHAUSTIVE all-tests || die
}
