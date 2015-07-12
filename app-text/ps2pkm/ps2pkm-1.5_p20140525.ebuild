# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ps2pkm/ps2pkm-1.5_p20140525.ebuild,v 1.2 2015/07/12 15:44:10 ago Exp $

EAPI=4

DESCRIPTION="Tool that converts a PostScript type1 font into a corresponding TeX PK font"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=dev-libs/kpathsea-6.2.0"
RDEPEND="
	!<app-text/texlive-core-2010
	!app-text/ptex
	${DEPEND}"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}
DOCS=( "ChangeLog" "CHANGES.type1" "README" "README.14m" "README.type1" )

src_configure() {
	econf --with-system-kpathsea
}
