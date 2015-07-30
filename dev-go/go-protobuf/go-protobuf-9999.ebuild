# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-protobuf/go-protobuf-9999.ebuild,v 1.1 2015/07/30 06:09:25 zmedico Exp $

EAPI=5

EGO_SRC=github.com/golang/protobuf
EGO_PN=${EGO_SRC}/...


if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="68c687dc49948540b356a6b47931c9be4fcd0245"
	SRC_URI="https://${EGO_SRC}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi
inherit golang-build

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="BSD"
SLOT="0/${PV}"
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

src_test() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	if [ -d "${T}/goroot/src/${EGO_SRC}" ]; then
		rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	fi
	if [ -d "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" ]; then
		rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" ||
			die
	fi

	GOROOT="${T}/goroot" golang-build_src_test
}

src_install() {
    rm -rf src/${EGO_SRC}/.git* || die
	golang-build_src_install
	dobin bin/*
}
