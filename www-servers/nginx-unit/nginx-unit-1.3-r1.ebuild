# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{5,6})

inherit python-single-r1

MY_P="unit-${PV}"
DESCRIPTION="A dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
MY_IUSE="perl python ruby"
IUSE="${MY_IUSE}"
REQUIRED_USE="|| ( ${MY_IUSE} ) python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	./configure \
		--prefix=/usr \
		--modules=$(get_libdir)/${PN} \
		--log=/var/log/${PN} \
		--state=/var/lib/${PN} \
		--pid=/run/${PN}.pid \
		--control=unix:/run/${PN}.sock || die "Core configuration failed"
	for flag in ${MY_IUSE} ; do
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
