# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpupower/cpupower-3.14.ebuild,v 1.3 2014/06/29 22:10:19 steev Exp $

EAPI=5
inherit multilib toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="mirror://kernel/linux/kernel/v3.x/linux-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="cpufreq_bench debug nls"

# File collision w/ headers of the deprecated cpufrequtils
RDEPEND="sys-apps/pciutils
	!<sys-apps/linux-misc-apps-3.6-r2
	!sys-power/cpufrequtils"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/linux-${PV}/tools/power/${PN}

pkg_setup() {
	myemakeargs=(
		DEBUG=$(usex debug true false)
		V=1
		CPUFREQ_BENCH=$(usex cpufreq_bench true false)
		NLS=$(usex nls true false)
		docdir=/usr/share/doc/${PF}/${PN}
		mandir=/usr/share/man
		libdir=/usr/$(get_libdir)
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		STRIP=true
		LDFLAGS="${LDFLAGS}"
		OPTIMIZATION="${CFLAGS}"
		)
}

src_prepare() {
	# -Wl,--as-needed compat
	local libs="-lcpupower -lrt $($(tc-getPKG_CONFIG) --libs-only-l libpci)"
	sed -i \
		-e "/$libs/{ s,${libs},,g; s,\$, ${libs},g;}" \
		-e "s:-O1 -g::" \
		Makefile || die
}

src_compile() {
	emake "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${myemakeargs[@]}" install
	dodoc README ToDo

	newconfd "${FILESDIR}"/conf.d-r2 ${PN}
	newinitd "${FILESDIR}"/init.d-r4 ${PN}
}
