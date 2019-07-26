# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="Library containing the definition of S-expressions and some base converters"
HOMEPAGE="https://github.com/janestreet/sexplib0"
SRC_URI="https://github.com/janestreet/sexplib0/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND} dev-ml/jbuilder"
