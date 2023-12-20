# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="A set of libraries for userspace access to RTAS on the PowerPC platform(s)"
HOMEPAGE="https://github.com/ibm-power-utilities/librtas"
SRC_URI="https://github.com/ibm-power-utilities/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc ppc64 ~ppc64-linux"
IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install docdir="${EPREFIX}"/usr/share/doc/${PF}
	find "${D}" -name '*.la' -delete || die
	# librtas_src/syscall_rmo.c: static const char *lockfile_path = "/var/lock/LCK..librtas";
	# this way we prevent sandbox violations in lscpu linked to rtas
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/run/lock/LCK..librtas"' > "${ED}"/etc/sandbox.d/50librtas || die
}
