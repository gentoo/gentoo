# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
CMAKE_MAKEFILE_GENERATOR="emake"
SSL_DEPS_SKIP=1
USE_RUBY="ruby27 ruby30 ruby31"

inherit cmake ruby-single ssl-cert systemd toolchain-funcs

DESCRIPTION="H2O - the optimized HTTP/1, HTTP/2 server"
HOMEPAGE="https://h2o.examp1e.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libh2o +mruby"

RDEPEND="acct-group/h2o
	acct-user/h2o
	dev-lang/perl
	!sci-libs/libh2o
	sys-libs/zlib
	libh2o? ( dev-libs/libuv )
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	mruby? (
		${RUBY_DEPS}
		|| (
			dev-libs/onigmo
			dev-libs/oniguruma
		)
	)"
BDEPEND="libh2o? ( virtual/pkgconfig )
	mruby? (
		sys-devel/bison
		virtual/pkgconfig
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-mruby.patch
	"${FILESDIR}"/${PN}-2.2-ruby30.patch
)

src_prepare() {
	cmake_src_prepare

	local ruby="ruby"
	if use mruby; then
		for ruby in ${RUBY_TARGETS_PREFERENCE}; do
			if has_version dev-lang/ruby:${ruby:4:1}.${ruby:5}; then
				break
			fi
			ruby=
		done
		[[ -z ${ruby} ]] && die "no suitable ruby version found"
	fi

	sed -i \
		-e "/INSTALL/s:\(/doc/${PN}\) :\1/html :" \
		-e "/INSTALL/s:\(/doc\)/${PN}:\1/${PF}:" \
		-e "s: ruby: ${ruby}:" \
		CMakeLists.txt

	sed -i "s:pkg-config:$(tc-getPKG_CONFIG):g" deps/mruby/lib/mruby/gem.rb
	tc-export CC
	export LD="$(tc-getCC)"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc/${PN}
		-DWITH_MRUBY=$(usex mruby)
		-DWITHOUT_LIBS=$(usex !libh2o)
		-DBUILD_SHARED_LIBS=$(usex libh2o)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	keepdir /var/www/localhost/htdocs

	insinto /etc/${PN}
	doins "${FILESDIR}"/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	fperms 0750 /var/log/${PN}
}

pkg_postinst() {
	if [[ ! -f "${EROOT}"/etc/ssl/${PN}/server.key ]]; then
		install_cert /etc/ssl/${PN}/server
		chown ${PN}:${PN} "${EROOT}"/etc/ssl/${PN}/server.*
	fi
}
