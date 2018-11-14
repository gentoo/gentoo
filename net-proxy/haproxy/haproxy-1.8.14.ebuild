# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

[[ ${PV} == *9999 ]] && SCM="git-r3"
inherit user versionator toolchain-funcs flag-o-matic systemd linux-info $SCM

MY_P="${PN}-${PV/_beta/-dev}"

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://www.haproxy.org"
if [[ ${PV} != *9999 ]]; then
	SRC_URI="http://haproxy.1wt.eu/download/$(get_version_component_range 1-2)/src/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
else
	EGIT_REPO_URI="http://git.haproxy.org/git/haproxy-$(get_version_component_range 1-2).git/"
	EGIT_BRANCH=master
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="+crypt doc examples libressl slz net_ns +pcre pcre-jit pcre2 pcre2-jit ssl
systemd +threads tools vim-syntax +zlib lua device-atlas 51degrees wurfl"
REQUIRED_USE="pcre-jit? ( pcre )
	pcre2-jit? ( pcre2 )
	pcre? ( !pcre2 )
	device-atlas? ( pcre )
	?? ( slz zlib )"

DEPEND="
	pcre? (
		dev-libs/libpcre
		pcre-jit? ( dev-libs/libpcre[jit] )
	)
	pcre2? (
		dev-libs/libpcre
		pcre2-jit? ( dev-libs/libpcre2[jit] )
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0=[zlib?] )
		libressl? ( dev-libs/libressl:0= )
	)
	slz? ( dev-libs/libslz:= )
	zlib? ( sys-libs/zlib )
	lua? ( dev-lang/lua:5.3 )
	device-atlas? ( dev-libs/device-atlas-api-c )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGELOG CONTRIBUTING MAINTAINERS README )
CONTRIBS=( halog iprange )
# ip6range is present in 1.6, but broken.
version_is_at_least 1.7.0 $PV && CONTRIBS+=( ip6range spoa_example tcploop )
# TODO: mod_defender - requires apache / APR, modsecurity - the same
version_is_at_least 1.8.0 $PV && CONTRIBS+=( hpack )

haproxy_use() {
	(( $# != 2 )) && die "${FUNCNAME} <USE flag> <make option>"

	usex "${1}" "USE_${2}=1" "USE_${2}="
}

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy

	if use net_ns; then
		CONFIG_CHECK="~NET_NS"
		linux-info_pkg_setup
	fi
}

src_compile() {
	local -a args=(
		TARGET=linux2628
		USE_GETADDRINFO=1
		USE_TFO=1
	)

	# TODO: PCRE2_WIDTH?
	args+=( $(haproxy_use threads THREAD) )
	args+=( $(haproxy_use crypt LIBCRYPT) )
	args+=( $(haproxy_use net_ns NS) )
	args+=( $(haproxy_use pcre PCRE) )
	args+=( $(haproxy_use pcre-jit PCRE_JIT) )
	args+=( $(haproxy_use ssl OPENSSL) )
	args+=( $(haproxy_use slz SLZ) )
	args+=( $(haproxy_use zlib ZLIB) )
	args+=( $(haproxy_use lua LUA) )
	args+=( $(haproxy_use 51degrees 51DEGREES) )
	args+=( $(haproxy_use device-atlas DEVICEATLAS) )
	args+=( $(haproxy_use wurfl WURFL) )
	args+=( $(haproxy_use systemd SYSTEMD) )

	# For now, until the strict-aliasing breakage will be fixed
	append-cflags -fno-strict-aliasing

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
	emake -C contrib/systemd SBINDIR=/usr/sbin

	if use tools ; then
		for contrib in ${CONTRIBS[@]} ; do
			emake -C contrib/${contrib} \
				CFLAGS="${CFLAGS}" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
		done
	fi
}

src_install() {
	dosbin haproxy
	dosym ../sbin/haproxy /usr/bin/haproxy

	newconfd "${FILESDIR}/${PN}.confd" $PN
	newinitd "${FILESDIR}/${PN}.initd-r6" $PN

	doman doc/haproxy.1

	systemd_dounit contrib/systemd/haproxy.service

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
		has halog "${CONTRIBS[@]}" && dobin contrib/halog/halog
		has "iprange" "${CONTRIBS[@]}" && newbin contrib/iprange/iprange haproxy_iprange
		has "ip6range" "${CONTRIBS[@]}" && newbin contrib/ip6range/ip6range haproxy_ip6range
		has "spoa_example" "${CONTRIBS[@]}" && newbin contrib/spoa_example/spoa haproxy_spoa_example
		has "spoa_example" "${CONTRIBS[@]}" && newdoc contrib/spoa_example/README README.spoa_example
		has "tcploop" "${CONTRIBS[@]}" && newbin contrib/tcploop/tcploop haproxy_tcploop
		has "hpack" "${CONTRIBS[@]}" && newbin contrib/hpack/gen-rht haproxy_hpack
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.cfg
		dodoc examples/seamless_reload.txt
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/haproxy.vim
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
			einfo "   ${EROOT}usr/share/doc/${PF}"
		fi
	fi
}
