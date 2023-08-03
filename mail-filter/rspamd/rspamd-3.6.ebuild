# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake lua-single pax-utils systemd tmpfiles

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rspamd/rspamd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rspamd/rspamd/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Rapid spam filtering system"
HOMEPAGE="
	https://rspamd.com
	https://github.com/rspamd/rspamd
"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-1 BSD-2 CC0-1.0 LGPL-3 MIT public-domain unicode ZLIB"
SLOT="0"
IUSE="blas cpu_flags_x86_ssse3 jemalloc +jit selinux test"
RESTRICT="!test? ( test )"

# A part of tests use ffi luajit extension
REQUIRED_USE="${LUA_REQUIRED_USE}
	test? ( lua_single_target_luajit )"

RDEPEND="${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/LuaBitOp[${LUA_USEDEP}]
		dev-lua/lua-argparse[${LUA_USEDEP}]
	')
	acct-group/rspamd
	acct-user/rspamd
	app-arch/zstd:=
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libev
	dev-libs/libfmt:=
	dev-libs/libpcre2:=[jit=]
	dev-libs/libsodium:=
	dev-libs/openssl:0=[-bindist(-)]
	dev-libs/snowball-stemmer:=
	>=dev-libs/xxhash-0.8.0
	sys-apps/file
	sys-libs/zlib
	blas? (
		virtual/blas
		virtual/lapack
	)
	cpu_flags_x86_ssse3? ( dev-libs/hyperscan )
	jemalloc? ( dev-libs/jemalloc:= )
	selinux? ( sec-policy/selinux-spamassassin )
"
DEPEND="${RDEPEND}
	dev-cpp/doctest
"
BDEPEND="
	dev-lang/perl
	dev-util/ragel
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/rspamd-3.6-cmake-lua-version.patch"
	"${FILESDIR}/rspamd-3.6-unbundle-lua.patch"
	"${FILESDIR}/rspamd-3.6-unbundle-snowball.patch"
	"${FILESDIR}/rspamd-3.6-fix-tests.patch"
)

src_prepare() {
	cmake_src_prepare

	rm -vrf contrib/{doctest,fmt,lua-{argparse,bit},snowball,xxhash,zstd} || die

	> cmake/Toolset.cmake || die #827550

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
		-DLIBDIR="/usr/$(get_libdir)/rspamd"

		-DSYSTEM_DOCTEST=ON
		-DSYSTEM_FMT=ON
		-DSYSTEM_XXHASH=ON
		-DSYSTEM_ZSTD=ON

		-DENABLE_BLAS=$(usex blas ON OFF)
		-DENABLE_HYPERSCAN=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_JEMALLOC=$(usex jemalloc ON OFF)
		-DENABLE_LUAJIT=$(usex lua_single_target_luajit ON OFF)
		-DENABLE_PCRE2=ON
	)
	cmake_src_configure
}

src_test() {
	cmake_build run-test
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

	for ver in ${REPLACING_VERSIONS}; do
		if ver_test "${ver}" -eq "3.4"; then
			elog "rspamd-3.4 is known to segfault when it is updated from older version due"
			elog "to a page-alignment of hyperscan .unser files. The issue was patched in"
			elog "rspamd-3.4-r1 ebuild revision. All possibly broken .unser files will be"
			elog "automaticaly removed. See https://github.com/rspamd/rspamd/issues/4329 for"
			elog "more information."

			find "${EROOT}/var/lib/rspamd" -type f -name '*.unser' -delete
		fi
	done
}
