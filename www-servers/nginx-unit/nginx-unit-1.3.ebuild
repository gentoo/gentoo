# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://unit.nginx.org/download/unit-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="perl python"
REQUIRED_USE="|| ( ${IUSE} )"
DEPEND="perl? ( dev-lang/perl:= )
	python? ( dev-lang/python:= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/unit-${PV}"

src_configure() {
	./configure \
		--prefix=/usr \
		--log=/var/log/${PN} \
		--state=/var/lib/${PN} \
		--pid=/run/${PN}.pid \
		--control=unix:/run/${PN}.sock || die "Core configuration failed"
	for flag in ${IUSE} ; do
		if use ${flag} ; then
			./configure ${flag} || die "Module configuration failed: ${flag}"
		fi
	done
}

src_install() {
	default
	keepdir /var/lib/${PN}
	fperms 0770 /var/lib/${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
