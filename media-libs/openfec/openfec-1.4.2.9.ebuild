# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library of various AL-FEC codecs"
HOMEPAGE="https://github.com/roc-streaming/openfec http://openfec.org/"
SRC_URI="https://github.com/roc-streaming/openfec/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# See https://github.com/roc-streaming/openfec/blob/d87b258e3de3cdddf700b40e94c51ec9bd44a47f/CHANGELOG#L47.
LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="amd64"

src_test() {
	cmake_src_test tests
}
