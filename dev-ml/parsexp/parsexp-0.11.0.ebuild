# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="S-expression parsing library"
HOMEPAGE="https://github.com/janestreet/parsexp"
SRC_URI="https://github.com/janestreet/parsexp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-ml/sexplib0"
DEPEND="${RDEPEND} dev-ml/jbuilder"

src_test() {
	jbuilder runtest || die
}
