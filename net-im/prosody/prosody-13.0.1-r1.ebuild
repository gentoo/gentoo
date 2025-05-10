# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3..4} )
LUA_REQ_USE="deprecated(+)"

inherit eapi9-ver lua-single systemd tmpfiles toolchain-funcs

DESCRIPTION="Prosody is a modern XMPP communication server"
HOMEPAGE="https://prosody.im/"
SRC_URI="https://prosody.im/downloads/source/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="icu +idn +libevent ldap mysql postgres selinux +sqlite +ssl test +zlib"
REQUIRED_USE="
	^^ ( icu idn )
	${LUA_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

DEPEND="
	acct-group/prosody
	acct-user/prosody
	$(lua_gen_cond_dep 'dev-lua/luaexpat[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/luafilesystem[${LUA_USEDEP}]')
	dev-lua/luarocks[${LUA_SINGLE_USEDEP}]
	$(lua_gen_cond_dep 'dev-lua/luasocket[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/lua-unbound[${LUA_USEDEP}]')
	$(lua_gen_cond_dep 'dev-lua/readline[${LUA_USEDEP}]')
	icu? ( dev-libs/icu:= )
	idn? ( net-dns/libidn:= )
	ldap? ( $(lua_gen_cond_dep 'dev-lua/lualdap[${LUA_USEDEP}]') )
	libevent? ( $(lua_gen_cond_dep 'dev-lua/luaevent[${LUA_USEDEP}]') )
	dev-libs/openssl:0=
	mysql? ( $(lua_gen_cond_dep 'dev-lua/luadbi[mysql,${LUA_USEDEP}]') )
	postgres? ( $(lua_gen_cond_dep 'dev-lua/luadbi[postgres,${LUA_USEDEP}]') )
	sqlite? ( $(lua_gen_cond_dep 'dev-lua/luadbi[sqlite,${LUA_USEDEP}]') )
	ssl? ( $(lua_gen_cond_dep 'dev-lua/luasec[${LUA_USEDEP}]') )
	zlib? ( $(lua_gen_cond_dep 'dev-lua/lua-zlib[${LUA_USEDEP}]') )
	${LUA_DEPS}
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-jabber )
"

BDEPEND="
	virtual/pkgconfig
	test? ( $(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]') )
"

PATCHES=( "${FILESDIR}/${PN}-0.12.0-gentoo.patch" )

src_prepare() {
	default

	# Set correct plugin path for optional net-im/prosody-modules package
	sed -e "s/GENTOO_LIBDIR/$(get_libdir)/g" -i prosody.cfg.lua.dist || die
}

src_configure() {
	local myeconfargs=(
		--add-cflags="${CFLAGS}"
		--add-ldflags="${LDFLAGS}"
		--c-compiler="$(tc-getCC)"
		--datadir="${EPREFIX}/var/lib/prosody"
		--idn-library="$(usex idn 'idn' 'icu')"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--linker="$(tc-getCC)"
		--lua-version="$(ver_cut 1-2 $(lua_get_version))"
		--no-example-certs
		--ostype="linux"
		--prefix="${EPREFIX}/usr"
		--runwith="${ELUA}"
		--sysconfdir="${EPREFIX}/etc/prosody"
		--with-lua-include="${EPREFIX}/$(lua_get_include_dir)"
		--with-lua-lib="${EPREFIX}/$(lua_get_cmod_dir)"
	)

	# Since the configure script is handcrafted,
	# and yells at unknown options, do not use 'econf'.
	./configure "${myeconfargs[@]}" || die

	rm makefile || die
	mv GNUmakefile Makefile || die
}

src_install() {
	default

	keepdir /var/lib/prosody

	newinitd "${FILESDIR}"/prosody.initd-r6 prosody
	systemd_newunit "${FILESDIR}"/prosody.service-r4 prosody.service

	newtmpfiles "${FILESDIR}"/prosody.tmpfilesd-r2 prosody.conf
}

pkg_postinst() {
	tmpfiles_process prosody.conf

	# Starting with >=0.12.0, the prosody configuration is now in
	# /etc/prosody and no longer in /etc/jabber.
	# See if we need to migrate the configuration. Furthermore,
	# prosody no longer runs under the, shared via net-im/jabber-base,
	# 'jabber' use, but under its own user.
	# This increase isolation and hence robustness and security.
	if ver_replacing -lt 0.12.0; then
		local -A dirs_to_migrate=(
			[/etc/jabber]=/etc/prosody
			[/var/log/jabber]=/var/log/prosody
			[/var/spool/jabber]=/var/lib/prosody
		)

		for src_dir in "${!dirs_to_migrate[@]}"; do
			local eroot_src_dir="${EROOT}/${src_dir}"
			local eroot_dst_dir="${EROOT}/${dirs_to_migrate[${src_dir}]}"

			cp -r "${eroot_src_dir}"/. "${eroot_dst_dir}" || die "Could not copy ${eroot_src_dir} to ${eroot_dst_dir}"

			if [[ -f "${eroot_dst_dir}"/.keep_net-im_jabber-base-0 ]]; then
				rm "${eroot_dst_dir}"/.keep_net-im_jabber-base-0 || die
			fi

			if ! use prefix; then
				chown --recursive prosody:prosody "${eroot_dst_dir}" || die
			fi
		done

		# Update configuration file to match new pathes and permissions
		local mysedargs=(
			-e "'s#/etc/jabber#/etc/prosody#g'"
			-e "'s#/run/jabber#/run/prosody#g'"
			-e "'s#/var/log/jabber#/var/log/prosody#g'"
			-e "'s/prosody_user.*/prosody_user = \"prosody\";/g'"
			-e "'s/prosody_group.*/prosody_group = \"prosody\";/g'"
			-i /etc/prosody/prosody.cfg.lua
		)

		eval sed "${mysedargs[@]}" || die

		ewarn "Newer versions of the prosody (Gentoo) package use ${EROOT}/etc/prosody"
		ewarn "(just as upstream) and *not* anymore ${EROOT}/etc/jabber."
		ewarn "The files from ${EROOT}/etc/jabber where copied to ${EROOT}/etc/prosody."
		ewarn "Also prosody's spool directory became ${EROOT}/var/lib/prosody (was ${EROOT}/var/spool/jabbber)."
		ewarn "Please check your configuration."
	fi
}
