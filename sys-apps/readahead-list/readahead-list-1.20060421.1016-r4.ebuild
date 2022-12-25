# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Preloads files into the page cache to accelerate program loading"
HOMEPAGE="https://github.com/robbat2/readahead-list"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

DEPEND="virtual/os-headers"

PATCHES=(
	"${FILESDIR}/1.20060421.1016/"
)

src_prepare() {
	default

	# Drop once ${P}-modernisation.patch is in a release
	eautoreconf
}

src_configure() {
	econf --sbindir=/sbin
}

src_install() {
	default

	# Init scripts
	#cd "${S}/contrib/init/gentoo" || die
	#newinitd init.d-readahead-list readahead-list
	#newinitd init.d-readahead-list-early readahead-list-early
	#newconfd conf.d-readahead-list readahead-list
	newinitd "${FILESDIR}"/init.d-readahead-list readahead-list
	newinitd "${FILESDIR}"/init.d-readahead-list-early readahead-list-early
	newconfd "${FILESDIR}"/conf.d-readahead-list readahead-list

	# Default config
	insinto /etc/readahead-list
	cd "${S}/contrib/data" || die
	newins readahead.runlevel-default.list runlevel-default
	newins readahead.runlevel-boot.list runlevel-boot
	newins readahead._sbin_rc.list exec_sbin_rc

	# docs
	cd "${S}" || die
	if use doc; then
		docinto scripts
		dodoc contrib/scripts/*
	fi

	# Clean up a bit
	find "${ED}/usr/share/doc/${PF}/" -type f -name 'Makefile*' -exec rm -f \{\} \;
}

pkg_postinst() {
	einfo "You should add readahead-list to your runlevels:"
	einfo "  rc-update add readahead-list-early boot"
	einfo "  rc-update add readahead-list boot"
	einfo "Also consider customizing the lists in ${EROOT}/etc/readahead-list"
	einfo "for maximum performance gain."
}
