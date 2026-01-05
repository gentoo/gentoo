# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_{11..14} )
RUST_MIN_VER="1.85.1"
RUST_OPTIONAL=1

inherit cargo flag-o-matic lua-single meson python-any-r1 toolchain-funcs

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://www.dnsdist.org/index.html"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/PowerDNS/pdns"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

SRC_URI+="
	doc? ( https://www.applied-asynchrony.com/distfiles/${PN}-docs-${PV}.tar.xz )
	yaml? ( https://www.applied-asynchrony.com/distfiles/${PN}-rust-${PV}-crates.tar.xz )
"

LICENSE="GPL-2"
SLOT="0"
IUSE="bpf cdb dnscrypt dnstap doc doh doh3 ipcipher lmdb quic regex snmp +ssl systemd test web xdp yaml"
RESTRICT="!test? ( test )"

REQUIRED_USE="${LUA_REQUIRED_USE}
		dnscrypt? ( ssl )
		doh? ( ssl )
		doh3? ( ssl quic )
		ipcipher? ( ssl )
		quic? ( ssl )"

RDEPEND="acct-group/dnsdist
	acct-user/dnsdist
	bpf? ( dev-libs/libbpf:= )
	cdb? ( dev-db/tinycdb:= )
	dev-libs/boost:=
	sys-libs/libcap
	dev-libs/libedit
	dev-libs/libsodium:=
	dnstap? ( dev-libs/fstrm )
	doh? ( net-libs/nghttp2:= )
	doh3? ( net-libs/quiche:= )
	lmdb? ( dev-db/lmdb:= )
	quic? ( net-libs/quiche )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:0= )
	xdp? ( net-libs/xdp-tools )
	${LUA_DEPS}
"

DEPEND="${RDEPEND}"
BDEPEND="$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	virtual/pkgconfig
	yaml? ( ${RUST_DEPEND} )
"

# special requirements for live
if [[ ${PV} == *9999* ]] ; then
	BDEPEND+=" dev-util/ragel"
	S="${S}/pdns/dnsdistdist"
fi

PATCHES=(
	"${FILESDIR}"/2.0.2-roundrobin-fast-path.patch
	"${FILESDIR}"/2.0.2-speed-up-cache-hits.patch
)

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
	use yaml && rust_pkg_setup
}

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

# git-r3 overrides automatic SRC_URI unpacking
src_unpack() {
	default

	if [[ ${PV} == *9999* ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	default

	# clean up duplicate file
	rm -f README.md
}

src_configure() {
	# bug #822855
	append-lfs-flags

	# There is currently no reliable way to handle mixed C++/Rust + LTO
	# correctly: https://bugs.gentoo.org/963128
	if use yaml && tc-is-lto ; then
		ewarn "Disabling LTO because of mixed C++/Rust toolchains."
		filter-lto
	fi

	# some things can only be enabled/disabled by defines
	! use dnstap && append-cppflags -DDISABLE_PROTOBUF
	! use web && append-cppflags -DDISABLE_BUILTIN_HTML

	local emesonargs=(
		--sysconfdir="${EPREFIX}/etc/dnsdist"
		# always use libsodium
		-Dlibsodium=enabled
		-Dlua=${ELUA}
		# never try to build man pages (virtualenv)
		-Dman-pages=false
		# never use gnutls (openssl only)
		-Dtls-gnutls=disabled
		$(meson_feature bpf ebpf)
		$(meson_feature cdb)
		$(meson_feature dnscrypt)
		$(meson_feature dnstap)
		$(meson_feature doh dns-over-https)
		$(meson_feature doh nghttp2)
		$(meson_feature doh3 dns-over-http3)
		$(meson_feature ipcipher)
		$(meson_feature lmdb)
		$(meson_feature quic dns-over-quic)
		$(meson_feature regex re2)
		$(meson_feature snmp)
		$(meson_feature ssl libcrypto)
		$(meson_feature ssl tls-libssl)
		$(meson_feature ssl dns-over-tls)
		$(meson_feature systemd systemd-service)
		$(meson_use test unit-tests)
		$(meson_feature xdp xsk)
		$(meson_feature yaml)
	)

	meson_src_configure
}

# explicitly implement src_compile/test to override the
# otherwise automagic cargo_src_compile/test phases

src_compile() {
	cargo_gen_config
	cargo_env meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install

	use doc && dodoc -r "${WORKDIR}"/html

	insinto /etc/dnsdist
	doins "${FILESDIR}"/dnsdist.conf.example

	newconfd "${FILESDIR}"/dnsdist.confd ${PN}
	newinitd "${FILESDIR}"/dnsdist.initd ${PN}
}

pkg_postinst() {
	elog "dnsdist provides multiple instances support. You can create more instances"
	elog "by symlinking the dnsdist init script to another name."
	elog
	elog "The name must be in the format dnsdist.<suffix> and dnsdist will use the"
	elog "/etc/dnsdist/dnsdist-<suffix>.conf configuration file instead of the default."
}
