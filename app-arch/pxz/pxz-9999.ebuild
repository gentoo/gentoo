# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pxz/pxz-9999.ebuild,v 1.1 2011/08/17 18:20:14 vapier Exp $

EAPI="3"

inherit toolchain-funcs flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/jnovy/pxz.git"
	inherit git-2
else
	MY_PV=${PV/_}
	case ${MY_PV} in
	*beta?*) MY_PV="${MY_PV/beta/beta.}git" ;;
	esac
	MY_P="${PN}-${MY_PV}"
	SRC_URI="http://jnovy.fedorapeople.org/pxz/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P/beta*/beta}
fi

DESCRIPTION="parallel LZMA compressor (no parallel decompression!)"
HOMEPAGE="http://jnovy.fedorapeople.org/pxz/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# needs the library from xz-utils
# needs the libgomp library from gcc at runtime
DEPEND="app-arch/xz-utils
	sys-devel/gcc[openmp]"
RDEPEND="${DEPEND}"

src_compile() {
	append-lfs-flags
	CFLAGS="${CFLAGS} ${CPPFLAGS}" \
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
