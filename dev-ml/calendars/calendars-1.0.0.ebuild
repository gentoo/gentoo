# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Convert dates between gregorian/julian/french/hebrew calendars"
HOMEPAGE="https://github.com/geneweb/calendars"
SRC_URI="https://github.com/geneweb/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-ml/ounit2 )"
