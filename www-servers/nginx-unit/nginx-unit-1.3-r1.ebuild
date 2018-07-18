# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="unit-${PV}"

DESCRIPTION="A dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="perl python ruby"
REQUIRED_USE="|| ( ${IUSE} )"

DEPEND="perl? ( dev-lang/perl:= )
	python? ( dev-lang/python:= )
	ruby? ( dev-lang/ruby:= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

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
	diropts -m 0770
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
