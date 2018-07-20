# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Preloads files into the page cache to accelerate program loading"
HOMEPAGE="https://github.com/robbat2/readahead-list"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.3.patch"
	"${FILESDIR}/${P}-gcc6.patch"
)

src_configure() {
	econf --sbindir=/sbin
}

src_install() {
	default

	# init scripts
	#cd "${S}/contrib/init/gentoo/"
	newinitd "${FILESDIR}"/init.d-readahead-list readahead-list
	newinitd "${FILESDIR}"/init.d-readahead-list-early readahead-list-early
	newconfd "${FILESDIR}"/conf.d-readahead-list readahead-list

	# default config
	insinto /etc/readahead-list
	cd "${S}/contrib/data"
	newins readahead.runlevel-default.list runlevel-default
	newins readahead.runlevel-boot.list runlevel-boot
	newins readahead._sbin_rc.list exec_sbin_rc

	# docs
	cd "${S}"
	if use doc; then
		docinto scripts
		dodoc contrib/scripts/*
	fi
	# clean up a bit
	find "${D}/usr/share/doc/${PF}/" -type f -name 'Makefile*' -exec rm -f \{\} \;
}

pkg_postinst() {
	einfo "You should add readahead-list to your runlevels:"
	einfo "  rc-update add readahead-list-early boot"
	einfo "  rc-update add readahead-list boot"
	einfo "Also consider customizing the lists in /etc/readahead-list"
	einfo "for maximum performance gain."
}
