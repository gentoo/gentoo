# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="https://gitlab.com/cespedes/ltrace"
SRC_URI="https://gitlab.com/cespedes/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug elfutils selinux test unwind"

REQUIRED_USE="?? ( elfutils unwind )"

RDEPEND="virtual/libelf:=
	elfutils? ( dev-libs/elfutils )
	selinux? ( sys-libs/libselinux )
	unwind? ( sys-libs/libunwind:= )"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs
	test? ( dev-util/dejagnu )"

# Effectively abandoned upstream. Extremely sensitive to the sandbox, versions
# of core libraries, kernel security settings...
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.91-debian-patchset-6.4.patch
	"${FILESDIR}"/${PN}-0.7.3-CXX-for-tests.patch
	"${FILESDIR}"/${PN}-0.7.3-alpha-protos.patch
	"${FILESDIR}"/${PN}-0.7.3-ia64.patch
	"${FILESDIR}"/${PN}-0.7.3-ia64-pid_t.patch
	"${FILESDIR}"/${PN}-0.7.3-musl-host.patch
	"${FILESDIR}"/${PN}-0.7.3-print-test-pie.patch
	"${FILESDIR}"/${PN}-0.7.91-pid_t.patch
	"${FILESDIR}"/${PN}-0.7.91-tuple-tests.patch
)

src_prepare() {
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
		$(use_with elfutils) \
		$(use_with unwind libunwind)
}
