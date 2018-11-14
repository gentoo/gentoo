# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit java-pkg-opt-2 linux-info user

DESCRIPTION="A transparent low-overhead system-wide profiler"
HOMEPAGE="http://oprofile.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="java pch"

RDEPEND=">=dev-libs/popt-1.7-r1
	sys-libs/binutils-libs:=
	>=sys-libs/glibc-2.3.2-r1
	java? ( >=virtual/jdk-1.5:= )
	ppc64? ( dev-libs/libpfm )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.31"

CONFIG_CHECK="PERF_EVENTS"
ERROR_PERF_EVENTS="CONFIG_PERF_EVENTS is mandatory for ${PN} to work."

pkg_setup() {
	linux-info_pkg_setup
	if ! kernel_is -ge 2 6 31; then
		echo
		ewarn "Support for kernels before 2.6.31 has been dropped in ${PN}-1.0.0."
		echo
	fi

	# Required for JIT support, see README_PACKAGERS
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}

	use java && java-pkg_init
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable pch) \
		$(use_with java java ${JAVA_HOME})
}

src_install() {
	emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}" install

	dodoc ChangeLog* README TODO
	echo "LDPATH=${PREFIX}/usr/$(get_libdir)/${PN}" > "${T}/10${PN}" || die
	doenvd "${T}/10${PN}"
}

pkg_postinst() {
	echo
	elog "Starting from ${PN}-1.0.0 opcontrol was removed, use operf instead."
	elog "CONFIG_OPROFILE is no longer used, you may remove it from your kernels."
	elog "Please read manpages and this html doc:"
	elog "  /usr/share/doc/${PF}/${PN}.html"
	echo
}
