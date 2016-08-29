# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils systemd

DESCRIPTION="The prelude log analyzer"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tls icu"

RDEPEND="dev-libs/libprelude
	dev-libs/libpcre
	icu? ( dev-libs/icu )
	tls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-configure.patch"
	"${FILESDIR}/${P}-conf.patch"
	"${FILESDIR}/${P}-run.patch"
)

src_prepare() {
	default_src_prepare

	mv "${S}/configure.in" "${S}/configure.ac" || die "mv failed"

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		$(use_enable icu) \
		$(use_enable tls gnutls)
}

src_install() {
	default_src_install

	rm -rv "${D}/run" || die "rm failed"
	keepdir /var/${PN}

	prune_libtool_files --modules

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
