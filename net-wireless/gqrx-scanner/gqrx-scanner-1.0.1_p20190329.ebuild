# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="frequency scanner for Gqrx Software Defined Radio receiver"
HOMEPAGE="https://github.com/neural75/gqrx-scanner"
COMMIT="46c09462c5e296fe1ee9c9ffe1fa6dd69e2ae128"
SRC_URI="https://github.com/neural75/gqrx-scanner/archive/46c09462c5e296fe1ee9c9ffe1fa6dd69e2ae128.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="net-wireless/gqrx"
