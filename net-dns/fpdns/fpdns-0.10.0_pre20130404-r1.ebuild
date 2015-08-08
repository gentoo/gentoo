# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-module

DESCRIPTION="Fingerprinting DNS servers"
HOMEPAGE="https://github.com/kirei/fpdns/"

MY_P="${PN}-${PV##*_pre}"
SRC_URI="https://github.com/kirei/fpdns/archive/20130404.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-perl/Net-DNS-0.74"

S="${WORKDIR}"/"${MY_P}"

src_prepare() {
	## fixes https://github.com/kirei/fpdns/issues/6
	epatch "${FILESDIR}/${P}.ro-header.patch"
}

src_install() {
	newbin apps/fpdns fpdns
	insinto "${VENDOR_LIB}"/Net/DNS/
	doins lib/Net/DNS/Fingerprint.pm
}
