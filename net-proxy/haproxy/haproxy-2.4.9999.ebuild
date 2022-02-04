# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

LUA_COMPAT=( lua5-3 )

[[ ${PV} == *9999 ]] && SCM="git-r3"
inherit toolchain-funcs flag-o-matic lua-single systemd linux-info ${SCM}

MY_P="${PN}-${PV/_beta/-dev}"

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://www.haproxy.org"
if [[ ${PV} != *9999 ]]; then
	SRC_URI="http://haproxy.1wt.eu/download/$(ver_cut 1-2)/src/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
else
	EGIT_REPO_URI="http://git.haproxy.org/git/haproxy-$(ver_cut 1-2).git/"
	EGIT_BRANCH=master
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
IUSE="+crypt doc examples +slz +net_ns +pcre pcre-jit pcre2 pcre2-jit prometheus-exporter
ssl systemd +threads tools vim-syntax zlib lua device-atlas 51degrees wurfl"
REQUIRED_USE="pcre-jit? ( pcre )
	pcre2-jit? ( pcre2 )
	pcre? ( !pcre2 )
	lua? ( ${LUA_REQUIRED_USE} )
	device-atlas? ( pcre )
	?? ( slz zlib )"

BDEPEND="virtual/pkgconfig"
DEPEND="
	crypt? ( virtual/libcrypt:= )
	pcre? (
		dev-libs/libpcre
		pcre-jit? ( dev-libs/libpcre[jit] )
	)
	pcre2? (
		dev-libs/libpcre2:=
		pcre2-jit? ( dev-libs/libpcre2:=[jit] )
	)
	ssl? (
		dev-libs/openssl:0=
	)
	systemd? ( sys-apps/systemd )
	zlib? ( sys-libs/zlib )
	lua? ( ${LUA_DEPS} )
	device-atlas? ( dev-libs/device-atlas-api-c )"
RDEPEND="${DEPEND}
	acct-group/haproxy
	acct-user/haproxy"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGELOG CONTRIBUTING MAINTAINERS README )
EXTRAS=( admin/halog admin/iprange dev/tcploop dev/hpack )

haproxy_use() {
	(( $# != 2 )) && die "${FUNCNAME} <USE flag> <make option>"

	usex "${1}" "USE_${2}=1" "USE_${2}="
}

pkg_setup() {
	use lua && lua-single_pkg_setup
	if use net_ns; then
		CONFIG_CHECK="~NET_NS"
		linux-info_pkg_setup
	fi
}

src_compile() {
	local -a args=(
		V=1
		TARGET=linux-glibc
	)

	# TODO: PCRE2_WIDTH?
	args+=( $(haproxy_use threads THREAD) )
	args+=( $(haproxy_use crypt LIBCRYPT) )
	args+=( $(haproxy_use net_ns NS) )
	args+=( $(haproxy_use pcre PCRE) )
	args+=( $(haproxy_use pcre-jit PCRE_JIT) )
	args+=( $(haproxy_use pcre2 PCRE2) )
	args+=( $(haproxy_use pcre2-jit PCRE2_JIT) )
	args+=( $(haproxy_use ssl OPENSSL) )
	args+=( $(haproxy_use slz SLZ) )
	args+=( $(haproxy_use zlib ZLIB) )
	args+=( $(haproxy_use lua LUA) )
	args+=( $(haproxy_use 51degrees 51DEGREES) )
	args+=( $(haproxy_use device-atlas DEVICEATLAS) )
	args+=( $(haproxy_use wurfl WURFL) )
	args+=( $(haproxy_use systemd SYSTEMD) )
	args+=( $(haproxy_use prometheus-exporter PROMEX) )

	# Bug #668002
	if use ppc || use arm || use hppa; then
		TARGET_LDFLAGS=-latomic
	fi

	# HAProxy really needs some of those "SPEC_CFLAGS", like -fno-strict-aliasing
	emake CFLAGS="${CFLAGS} \$(SPEC_CFLAGS)" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) EXTRA_OBJS="${EXTRA_OBJS}"	TARGET_LDFLAGS="${TARGET_LDFLAGS}" PCRE_LIB=${ERROT}/usr/$(get_libdir) ${args[@]}
	emake -C admin/systemd CFLAGS="${CFLAGS} \$(SPEC_CFLAGS)" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) EXTRA_OBJS="${EXTRA_OBJS}" TARGET_LDFLAGS="${TARGET_LDFLAGS}" PCRE_LIB=${ERROT}/usr/$(get_libdir) SBINDIR=/usr/sbin

	if use tools ; then
		for extra in ${EXTRAS[@]} ; do
			if [ "${extra}" = "admin/halog" ]; then
				emake CFLAGS="${CFLAGS} \$(SPEC_CFLAGS)" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) EXTRA_OBJS="${EXTRA_OBJS}" TARGET_LDFLAGS="${TARGET_LDFLAGS}" PCRE_LIB=${ERROT}/usr/$(get_libdir) ${args[@]} admin/halog/halog
			elif [ "${extra}" = "dev/hpack" ]; then
				emake CFLAGS="${CFLAGS} \$(SPEC_CFLAGS)" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) EXTRA_OBJS="${EXTRA_OBJS}" TARGET_LDFLAGS="${TARGET_LDFLAGS}" PCRE_LIB=${ERROT}/usr/$(get_libdir) ${args[@]} dev/hpack/{decode,gen-enc,gen-rht}
			else
				# Those two includes are a workaround for hpack Makefile missing those
				emake -C ${extra} \
					CFLAGS="${CFLAGS} -I../../include/ -I../../ebtree/" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
			fi
		done
	fi
}

src_install() {
	dosbin haproxy
	dosym ../sbin/haproxy /usr/bin/haproxy

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd-r6" ${PN}

	doman doc/haproxy.1

	systemd_dounit admin/systemd/haproxy.service

	einstalldocs

	# The errorfiles are used by upstream defaults.
	insinto /etc/haproxy/errors/
	doins examples/errorfiles/*

	if use doc; then
		dodoc ROADMAP doc/*.txt
		#if use lua; then
		# TODO: doc/lua-api/
		#fi
	fi

	if use tools ; then
		has admin/halog "${EXTRAS[@]}" && dobin admin/halog/halog
		has admin/iprange "${EXTRAS[@]}" && { newbin admin/iprange/iprange haproxy_iprange; newbin admin/iprange/ip6range haproxy_ip6range; }
		has dev/tcploop "${EXTRAS[@]}" && newbin dev/tcploop/tcploop haproxy_tcploop
		has dev/hpack "${EXTRAS[@]}" && {
			newbin dev/hpack/gen-rht haproxy_gen-rht
			newbin dev/hpack/gen-enc haproxy_gen-enc
			newbin dev/hpack/decode haproxy_decode
		}
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.cfg
		dodoc doc/seamless_reload.txt
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins admin/syntax-highlight/haproxy.vim
	fi
}

pkg_postinst() {
	if [[ ! -f "${EROOT}/etc/haproxy/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${EROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${EROOT}/usr/share/doc/${PF}"
		fi
	fi
}
