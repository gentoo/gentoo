# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Simple, capable content management system for producing static content"
HOMEPAGE="http://blaze.blackened.cz/"
SRC_URI="
	https://${PN}.googlecode.com/files/${P}.tar.gz
	doc? ( https://${PN}.googlecode.com/files/${PN}-doc-${PV}.tar.gz ) "

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-bash-completion.patch #bug 417953
	"${FILESDIR}"/${P}-makefile.patch
)

src_install() {
	emake \
		prefix="${ED}"/usr \
		config="${ED}"/etc \
		compdir="${D}"/$(get_bashcompdir) \
		docsdir="${ED}"/usr/share/doc/${PF} \
		install

	if use doc; then
		docinto html
		dodoc -r "${WORKDIR}"/${PN}-doc-${PV}/.
	fi
}
