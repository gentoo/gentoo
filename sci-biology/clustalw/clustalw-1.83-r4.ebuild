# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="General purpose multiple alignment program for DNA and proteins"
HOMEPAGE="http://www.embl-heidelberg.de/~seqanal/"
SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/unix/clustalw/${PN}${PV}.UNIX.tar.gz"
S="${WORKDIR}/${PN}${PV}"

LICENSE="clustalw"
SLOT="1"
KEYWORDS="amd64 ~ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

PATCHES=(
	"${FILESDIR}"/${PV}-as-needed.patch
	"${FILESDIR}"/${PV}-clang.patch
)

src_prepare() {
	default
	sed \
		-e "s|clustalw_help|${EPREFIX}/usr/share/doc/${PF}/clustalw_help|" \
		-i clustalw.c || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin clustalw
	dodoc README clustalv.doc clustalw{.doc,.ms,_help}
}
