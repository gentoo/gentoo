# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1

DESCRIPTION="httpstat visualizes cURL statistics in a way of beauty and clarity"
HOMEPAGE="https://github.com/reorx/httpstat"
SRC_URI="https://github.com/reorx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="net-misc/curl:*"

# Requires access to google.com and http2.akamai.com
RESTRICT="test"
PROPERTIES="test_network"

PATCHES=( "${FILESDIR}"/${PN}-1.2.1-gentoo-tests.patch )

python_test() {
	./httpstat_test.sh || die
}
