# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-sys/go-sys-9999.ebuild,v 1.4 2015/06/28 23:19:15 williamh Exp $

EAPI=5
EGO_PN=golang.org/x/sys/...
EGO_SRC=golang.org/x/sys

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
EGIT_COMMIT="58e109635f5d754f4b3a8a0172db65a52fcab866"
	SRC_URI="https://github.com/golang/sys/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi
inherit golang-build

DESCRIPTION="Go packages for low-level interaction with the operating system"
HOMEPAGE="https://godoc.org/golang.org/x/sys"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""
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
