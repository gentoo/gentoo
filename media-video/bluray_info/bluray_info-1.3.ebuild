# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Blu-ray disc tools: bluray_info, bluray_copy"
HOMEPAGE="https://github.com/beandog/bluray_info"
SRC_URI="mirror://sourceforge/bluray-info/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libbluray-1.0.0"
RDEPEND="${DEPEND}"
