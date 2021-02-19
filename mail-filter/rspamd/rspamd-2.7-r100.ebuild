# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit cmake lua-single pax-utils systemd tmpfiles

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rspamd/rspamd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rspamd/rspamd/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 x86"
fi

DESCRIPTION="Rapid spam filtering system"
HOMEPAGE="https://rspamd.com https://github.com/rspamd/rspamd"
LICENSE="Apache-2.0 Boost-1.0 BSD BSD-1 BSD-2 CC0-1.0 LGPL-3 MIT public-domain unicode ZLIB"
SLOT="0"
IUSE="blas cpu_flags_x86_ssse3 jemalloc +jit libressl pcre2"

REQUIRED_USE="${LUA_REQUIRED_USE}
	jit? ( lua_single_target_luajit )"

RDEPEND="${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/LuaBitOp[${LUA_USEDEP}]
	' lua5-{1,2})
	acct-group/rspamd
	acct-user/rspamd
	app-arch/zstd
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libev
	dev-libs/libsodium
	dev-libs/snowball-stemmer
	net-libs/libnsl
	sys-apps/file
	blas? (
		virtual/blas
		virtual/lapack
	)
	cpu_flags_x86_ssse3? ( dev-libs/hyperscan )
	jemalloc? ( dev-libs/jemalloc )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	pcre2? ( dev-libs/libpcre2[jit=] )
	!pcre2? ( dev-libs/libpcre[jit=] )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/ragel
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/rspamd-2.7-cmake-lua-version.patch"
	"${FILESDIR}/rspamd-2.6-unbundle-lua.patch"
	"${FILESDIR}/rspamd-2.7-unbundle-zstd.patch"
	"${FILESDIR}/rspamd-2.5-unbundle-snowball.patch"
)

src_prepare() {
	cmake_src_prepare

	rm -vrf contrib/{lua-bit,snowball,zstd} || die

	sed -i -e 's/User=_rspamd/User=rspamd/g' \
		rspamd.service \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-DCONFDIR=/etc/rspamd
		-DRUNDIR=/var/run/rspamd
		-DDBDIR=/var/lib/rspamd
		-DLOGDIR=/var/log/rspamd
		-DENABLE_BLAS=$(usex blas ON OFF)
		-DENABLE_HYPERSCAN=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_JEMALLOC=$(usex jemalloc ON OFF)
		-DENABLE_LUAJIT=$(usex lua_single_target_luajit ON OFF)
		-DENABLE_PCRE2=$(usex pcre2 ON OFF)
	)
	cmake_src_configure
}

src_test() {
	cmake_src_test
}

src_install() {
	cmake_src_install

	newconfd "${FILESDIR}"/rspamd.conf rspamd
	newinitd "${FILESDIR}/rspamd-r7.init" rspamd
	systemd_newunit rspamd.service rspamd.service

	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf

	# Remove mprotect for JIT support
	if use lua_single_target_luajit; then
		pax-mark m "${ED}"/usr/bin/rspamd-* "${ED}"/usr/bin/rspamadm-*
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/rspamd-r1.logrotate rspamd

	diropts -o rspamd -g rspamd
	keepdir /var/{lib,log}/rspamd
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
