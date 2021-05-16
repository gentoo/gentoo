# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Command-line markdown to fb2 convertor"
HOMEPAGE="http://cdslow.org.ru/fictionup/"
SRC_URI="http://cdslow.org.ru/files/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libyaml"
RDEPEND="${DEPEND}"
