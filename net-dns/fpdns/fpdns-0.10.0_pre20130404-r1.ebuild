# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Fingerprinting DNS servers"
HOMEPAGE="https://github.com/kirei/fpdns/"
MY_P="${PN}-${PV##*_pre}"
SRC_URI="https://github.com/kirei/fpdns/archive/20130404.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/"${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-perl/Net-DNS-0.74"

PATCHES=(
	"${FILESDIR}"/${P}.ro-header.patch
)

src_install() {
	dobin apps/fpdns
	insinto "${VENDOR_LIB}"/Net/DNS/
	doins lib/Net/DNS/Fingerprint.pm
}
