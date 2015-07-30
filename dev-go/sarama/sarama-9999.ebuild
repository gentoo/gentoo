# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/sarama/sarama-9999.ebuild,v 1.1 2015/07/30 21:17:18 zmedico Exp $

EAPI=5

EGO_SRC=github.com/Shopify/${PN}
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	SRC_URI="https://${EGO_SRC}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi
inherit golang-build

DESCRIPTION="Sarama is a Go library for Apache Kafka"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="MIT"
SLOT="0/${PV}"
IUSE="test"
DEPEND="dev-go/go-eapache-queue
	dev-go/go-resiliency
	dev-go/go-snappy
	test? ( dev-go/go-spew )"
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
	# avoid toxiproxy dependency
	rm src/${EGO_SRC}/functional*_test.go || die
}

src_install() {
	rm -rf src/${EGO_SRC}/.git* || die
	golang-build_src_install
	rm bin/http_server || die
	dobin bin/*
}
