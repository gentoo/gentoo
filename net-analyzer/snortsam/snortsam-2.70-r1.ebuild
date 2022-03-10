# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs vcs-clean

DESCRIPTION="Snort plugin that allows automated blocking of IP addresses on several firewalls"
HOMEPAGE="http://www.snortsam.net/"
SRC_URI="http://www.snortsam.net/files/snortsam/${PN}-src-${PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="debug"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	ecvs_clean
}

src_configure() {
	use debug && append-cflags -DFWSAMDEBUG
	tc-export CC
}

src_compile() {
	sh makesnortsam.sh || die
}

src_install() {
	dobin snortsam

	find . -depth -type f -name '*.asc' -delete || die
	dodoc -r docs/. conf/.
}

pkg_postinst() {
	elog "To use snortsam with snort, you'll have to compile snort with USE=snortsam."
	elog "Read the INSTALL file to configure snort for snortsam, and configure"
	elog "snortsam for your particular firewall."
}
