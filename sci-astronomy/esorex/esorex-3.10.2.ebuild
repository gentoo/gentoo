# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/esorex/esorex-3.10.2.ebuild,v 1.1 2014/04/04 15:50:20 bicatali Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
AT_NO_RECURSIVE=1

inherit autotools-utils

DESCRIPTION="ESO Recipe Execution Tool to exec cpl scripts"
HOMEPAGE="http://www.eso.org/sci/software/cpl/esorex.html"
SRC_URI="ftp://ftp.eso.org/pub/dfs/pipelines/libraries/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=sci-astronomy/cpl-6.3:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.9.6-use-shared-libs.patch
	"${FILESDIR}"/${PN}-3.10-remove-private-ltdl.patch
	"${FILESDIR}"/${PN}-3.10-generate-manpage.patch
	"${FILESDIR}"/${PN}-3.10-remove-empty-configdir.patch
	"${FILESDIR}"/${PN}-3.10-set-default-plugin-path.patch
)

export CPLDIR="${EPREFIX}/usr"

src_install() {
	autotools-utils_src_install
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
