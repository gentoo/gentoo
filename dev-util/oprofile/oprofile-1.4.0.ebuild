# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools java-pkg-opt-2 linux-info

DESCRIPTION="A transparent low-overhead system-wide profiler"
HOMEPAGE="http://oprofile.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~sparc x86"
IUSE="apidoc java pch static-libs"

BDEPEND="
	apidoc? ( app-doc/doxygen[dot] )
	java? ( >=virtual/jdk-1.8:= )
"
CDEPEND="
	>=dev-libs/popt-1.7-r1
	sys-libs/binutils-libs:=
	elibc_glibc? ( >=sys-libs/glibc-2.3.2-r1 )
	ppc64? ( dev-libs/libpfm )
"
DEPEND="${CDEPEND}
	>=sys-kernel/linux-headers-2.6.31
"
RDEPEND="${CDEPEND}
	acct-user/oprofile
	acct-group/oprofile
"

CONFIG_CHECK="~PERF_EVENTS"
ERROR_PERF_EVENTS="CONFIG_PERF_EVENTS is mandatory for ${PN} to work."

pkg_setup() {
	linux-info_pkg_setup
	if ! kernel_is -ge 2 6 31; then
		echo
		ewarn "Support for kernels before 2.6.31 has been dropped in ${PN}-1.0.0."
		echo
	fi

	use java && java-pkg_init
}

src_prepare() {
	eapply "${FILESDIR}/musl.patch"
	eapply "${FILESDIR}/gcc12.patch"
	# bug 723092
	sed -i 's/==/=/g' configure.ac || die

	java-pkg-opt-2_src_prepare
	eautoreconf
}

src_configure() {
	local jh=""
	use java && jh="$(java-config -O)"
	econf \
		--disable-werror \
		$(use_enable pch) \
		$(use_with java java "${jh}")
}

src_compile() {
	default
	use apidoc && emake -C doc/srcdoc
}

src_install() {
	emake DESTDIR="${D}" htmldir="/usr/share/doc/${PF}" install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/${PN}/*.{a,la}
	use apidoc && dodoc -r doc/srcdoc/html

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
