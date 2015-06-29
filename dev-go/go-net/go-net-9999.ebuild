# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-net/go-net-9999.ebuild,v 1.6 2015/06/29 03:48:53 williamh Exp $

EAPI=5
EGO_PN=golang.org/x/net/...
EGO_SRC=golang.org/x/net

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="dfe268fd2bb5c793f4c083803609fce9806c6f80"
	SRC_URI="https://github.com/golang/net/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi
inherit golang-build

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://godoc.org/golang.org/x/net"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-text"
RDEPEND=""

if [[ ${PV} != *9999* ]]; then
src_unpack() {
	local f

	for f in ${A}
	do
		case "${f}" in
			*.tar|*.tar.gz|*.tar.bz2|*.tar.xz)
				local destdir=${WORKDIR}/${P}/src/${EGO_SRC}

				debug-print "${FUNCNAME}: unpacking ${f} to ${destdir}"

				# XXX: check whether the directory structure inside is
				# fine? i.e. if the tarball has actually a parent dir.
				mkdir -p "${destdir}" || die
				tar -C "${destdir}" -x --strip-components 1 \
					-f "${DISTDIR}/${f}" || die
				;;
			*)
				debug-print "${FUNCNAME}: falling back to unpack for ${f}"

				# fall back to the default method
				unpack "${f}"
				;;
		esac
	done
}
fi

src_prepare() {
	# disable broken tests
	sed -e 's:TestReadProppatch(:_\0:' \
		-i src/${EGO_SRC}/webdav/xml_test.go || die
	sed -e 's:TestPingGoogle(:_\0:' \
		-e 's:TestNonPrivilegedPing(:_\0:' \
		-i src/${EGO_SRC}/icmp/ping_test.go || die
}
