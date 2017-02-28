# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="ESO Recipe Execution Tool to exec cpl scripts"
HOMEPAGE="http://www.eso.org/sci/software/cpl/esorex.html"
SRC_URI="ftp://ftp.eso.org/pub/dfs/pipelines/libraries/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=sci-astronomy/cpl-6.3:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.9.6-use-shared-libs.patch
	"${FILESDIR}"/${PN}-3.10-remove-private-ltdl.patch
	"${FILESDIR}"/${PN}-3.10-generate-manpage.patch
	"${FILESDIR}"/${PN}-3.10-remove-empty-configdir.patch
	"${FILESDIR}"/${PN}-3.10-set-default-plugin-path.patch
)

export CPLDIR="${EPREFIX}/usr"

src_prepare() {
	default
	AT_NO_RECURSIVE=1 eautoreconf
}

src_install() {
	default
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
