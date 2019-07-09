# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{5,6,7})

inherit python-single-r1

MY_P="unit-${PV}"
DESCRIPTION="A dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
MY_USE="perl python ruby"
MY_USE_PHP="php5-6 php7-1 php7-2"
IUSE="${MY_USE} ${MY_USE_PHP}"
REQUIRED_USE="|| ( ${IUSE} ) python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="perl? ( dev-lang/perl:= )
	php5-6? ( dev-lang/php:5.6[embed] )
	php7-1? ( dev-lang/php:7.1[embed] )
	php7-2? ( dev-lang/php:7.2[embed] )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	./configure \
		--control=unix:/run/${PN}.sock \
		--ld-opt="${LDFLAGS}" \
		--log=/var/log/${PN} \
		--modules=$(get_libdir)/${PN} \
		--pid=/run/${PN}.pid \
		--prefix=/usr \
		--state=/var/lib/${PN} || die "Core configuration failed"
	for flag in ${MY_USE} ; do
		if use ${flag} ; then
			./configure ${flag} || die "Module configuration failed: ${flag}"
		fi
	done
	for flag in ${MY_USE_PHP} ; do
		if use ${flag} ; then
			local php_slot="/usr/$(get_libdir)/${flag/-/.}"
			./configure php \
				--module=${flag} \
				--config=${php_slot}/bin/php-config \
				--lib-path=${php_slot}/$(get_libdir) || die "Module configuration failed: ${flag}"
		fi
	done
}

src_install() {
	default
	diropts -m 0770
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
