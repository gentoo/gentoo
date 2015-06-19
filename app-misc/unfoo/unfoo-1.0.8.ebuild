# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/unfoo/unfoo-1.0.8.ebuild,v 1.5 2014/09/14 07:29:23 ago Exp $

EAPI=5

DESCRIPTION="A simple bash driven frontend to simplify decompression of files"
HOMEPAGE="http://obsoleet.org/code/unfoo"
SRC_URI="https://github.com/jlec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux"
IUSE="+minimal test"

COMMON_DEPS="
	|| (
		app-arch/bzip2
		app-arch/lbzip2[symlink]
		app-arch/pbzip2[symlink] )
	|| (
		app-arch/gzip
		app-arch/pigz[symlink] )
	app-arch/p7zip
	|| (
		app-arch/rar
		app-arch/unrar-gpl
		app-arch/unrar )
	app-arch/unace
	app-arch/unzip
	app-arch/xz-utils"
RDEPEND="!minimal? ( ${COMMON_DEPS} )"
DEPEND="test? ( ${COMMON_DEPS} )"

src_compile() { :; }

src_install() {
	dodoc README*
	dobin ${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		echo
		elog "unfoo can handle far more than just .tar*, but it requires some"
		elog "optional packages to do so. For a list, either consult the source"
		elog "(less /usr/bin/unfoo), or see http://obsoleet.org/code/unfoo"
		elog "To get full support please use USE=-minimal"
	elif [[ ${REPLACING_VERSIONS} < 1.0.7 ]]; then
		elog "To get full support please use USE=-minimal"
	fi
}
