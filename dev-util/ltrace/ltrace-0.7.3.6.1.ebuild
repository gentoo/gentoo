# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

LTRACE_V=$(ver_cut 1-3)
DB_V=$(ver_cut 4-5)

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="https://gitlab.com/cespedes/ltrace"
SRC_URI="
	mirror://debian/pool/main/l/${PN}/${PN}_${LTRACE_V}.orig.tar.bz2
	mirror://debian/pool/main/l/${PN}/${PN}_${LTRACE_V}-${DB_V}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="debug selinux test unwind"

RDEPEND="virtual/libelf:=
	selinux? ( sys-libs/libselinux )
	unwind? ( sys-libs/libunwind:= )"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs
	test? ( dev-util/dejagnu )"

# under musl tests need major work upstream, half of them does not work.
RESTRICT="
	!test? ( test )
	elibc_musl? ( test )
"

S=${WORKDIR}/${PN}-${LTRACE_V}

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.3-test-protos.patch #bug 421649
	"${FILESDIR}"/${PN}-0.7.3-alpha-protos.patch
	"${FILESDIR}"/${PN}-0.7.3-ia64.patch
	"${FILESDIR}"/${PN}-0.7.3-print-test-pie.patch
	"${FILESDIR}"/${PN}-0.7.3-ia64-pid_t.patch
	"${FILESDIR}"/${PN}-0.7.3-musl-host.patch #713428
	"${FILESDIR}"/${PN}-0.7.3-no-error.h.patch #713428
	"${FILESDIR}"/${PN}-0.7.3-no-error.h-2.patch #713428
	"${FILESDIR}"/${PN}-0.7.3-no-REG_NOERROR.patch #713428
	"${FILESDIR}"/${PN}-0.7.3-pid_t.patch #713428
	"${FILESDIR}"/${PN}-0.7.3-tuple-tests.patch
	"${FILESDIR}"/${PN}-0.7.3-CXX-for-tests.patch
	"${FILESDIR}"/${PN}-0.7.3-test-glibc-2.33.patch
	"${FILESDIR}"/${PN}-0.7.3-disable-munmap-test.patch
)

src_prepare() {
	eapply "${WORKDIR}"/debian/patches/[0-9]*

	default

	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	ac_cv_header_selinux_selinux_h=$(usex selinux) \
	ac_cv_lib_selinux_security_get_boolean_active=$(usex selinux) \
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with unwind libunwind)
}

src_test() {
	# On kernels with Yama enabled this will not run, even without sandbox,
	# unless /proc/sys/kernel/yama/ptrace_scope == 0. Just don't bother.
	# Note: we only delete it here in order to avoid Makefile.am patching.
	rm -f testsuite/ltrace.minor/attach-process.exp
	# sandbox redirects vfork() to fork(): bug # 774054
	# Let's avoid sandbox entirely.
	SANDBOX_ON=0 LD_PRELOAD= emake check
}
