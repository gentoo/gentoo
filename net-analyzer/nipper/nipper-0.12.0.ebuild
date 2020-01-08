# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}-cli-${PV}"
inherit cmake-utils

DESCRIPTION="Router configuration security analysis tool"
HOMEPAGE="http://nipper.titania.co.uk/"
SRC_URI="mirror://sourceforge/nipper/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/libnipper-0.12"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
