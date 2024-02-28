# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit flag-o-matic python-single-r1 systemd toolchain-funcs

MY_P="unit-${PV}"
DESCRIPTION="Dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://unit.nginx.org/download/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
MY_USE="perl python ruby"
MY_USE_PHP="php8-1 php8-2"
IUSE="${MY_USE} ${MY_USE_PHP} perl ssl"
REQUIRED_USE="|| ( ${IUSE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="perl? ( dev-lang/perl:= )
	php8-1? ( dev-lang/php:8.1[embed] )
	php8-2? ( dev-lang/php:8.2[embed] )
	python? ( ${PYTHON_DEPS} )
	ruby? (
		dev-lang/ruby:=
		dev-ruby/rubygems:=
	)
	ssl? ( dev-libs/openssl:0= )
	virtual/libcrypt:0="
RDEPEND="${DEPEND}
	acct-user/nginx-unit
	acct-group/nginx-unit"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	eapply_user
	sed -i '/^CFLAGS/d' auto/make || die
	default
}

src_configure() {
	local opt=(
		--control=unix:/run/${PN}.sock
		--log=/var/log/${PN}
		--modules=/usr/$(get_libdir)/${PN}
		--pid=/run/${PN}.pid
		--prefix=/usr
		--state=/var/lib/${PN}
		--user=${PN}
		--group=${PN}
	)

	use ssl && opt+=( --openssl )
	export AR="$(tc-getAR)"
	export CC="$(tc-getCC)"
	./configure ${opt[@]} --ld-opt="${LDFLAGS}" || die "Core configuration failed"

	# Modules require position-independent code
	append-cflags $(test-flags-CC -fPIC)

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

	if use perl ; then
		echo "1"
		echo "D is ${D}"
		emake DESTDIR="${D}/" perl-install
	fi

	rm -rf "${ED}"/usr/var

	diropts -m 0770
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}"/nginx-unit.confd nginx-unit
	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
}
