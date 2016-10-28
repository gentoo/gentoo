# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools user

DESCRIPTION="RSS downloader for Tranmission"
HOMEPAGE="https://github.com/1100101/Automatic"
SRC_URI="https://github.com/1100101/Automatic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${P^}"

RDEPEND="dev-libs/libxml2:2
	dev-libs/libpcre:3
	net-misc/curl"
DEPEND="${RDEPEND}
	app-admin/logrotate"

src_prepare() {
	default

	# https://bugs.gentoo.org/426262
	mv configure.{in,ac} || die "rename failed"

	# Remove CFLAGS and CXXFLAGS defined by upstream
	sed -i \
		-e 's/CFLAGS="-Wdeclaration-after-statement -O3 -funroll-loops"/CFLAGS+=""/' \
		-e 's/CXXFLAGS="-O3 -funroll-loops"/CXXFLAGS+=""/' \
		configure.ac || die "sed for CXXFLAGS and CFLAGS failed"

	eautoreconf
}

src_install() {
	# Install and copy documentation
	default

	# Install Gentoo init script and its config
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	# Create automatic related directories
	keepdir /var/lib/${PN}/
	keepdir /var/log/${PN}/

	# Install logrotate for automatic
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	# Add automatic group and user to system
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	elog ""
	elog "To run automatic you should move /etc/automatic.conf-sample to /etc/automatic.conf and config it."
	elog "If things go wrong, increase verbose level in /etc/conf.d/automatic and check log file in /var/log/automatic/"
	elog ""
}
