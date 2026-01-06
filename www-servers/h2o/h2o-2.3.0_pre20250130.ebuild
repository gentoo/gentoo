# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
SSL_DEPS_SKIP=1
USE_RUBY="ruby31 ruby32 ruby33"

inherit cmake flag-o-matic ruby-single ssl-cert systemd toolchain-funcs vcs-snapshot

EGIT_COMMIT="26b116e9536be8cf07036185e3edf9d721c9bac2"

DESCRIPTION="H2O - the optimized HTTP/1, HTTP/2 server"
HOMEPAGE="https://h2o.examp1e.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libh2o +mruby"

RDEPEND="acct-group/h2o
	acct-user/h2o
	dev-lang/perl
	dev-libs/openssl:0=
	!sci-libs/libh2o
	sys-libs/libcap
	virtual/zlib:=
	libh2o? (
		app-arch/brotli
		dev-libs/libuv
	)"
DEPEND="${RDEPEND}
	mruby? (
		${RUBY_DEPS}
		|| (
			dev-libs/onigmo
			dev-libs/oniguruma
		)
	)"
BDEPEND="virtual/pkgconfig
	mruby? ( app-alternatives/yacc )"

PATCHES=( "${FILESDIR}"/${PN}-2.3-mruby.patch )

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
	if use libh2o; then
		# -Werror=strict-aliasing
		# https://bugs.gentoo.org/967654
		# https://github.com/h2o/h2o/issues/3541
		#
		# Fixed upstream in git, post 2.3.0-beta2
		append-flags -fno-strict-aliasing
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc/${PN}
		-DWITH_CCACHE=OFF
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
