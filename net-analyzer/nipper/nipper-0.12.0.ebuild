# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="${PN}-cli-${PV}"

DESCRIPTION="Router configuration security analysis tool"
HOMEPAGE="http://nipper.titania.co.uk/"
SRC_URI="mirror://sourceforge/nipper/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=net-libs/libnipper-0.12"
RDEPEND="${DEPEND}"
