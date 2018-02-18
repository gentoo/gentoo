# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz/"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P/_/-}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

KNOT_MODULES=(
	"+dnsproxy"
	"dnstap"
	"+noudp"
	"+onlinesign"
	"rosedb"
	"+rrl"
	"+stats"
	"+synthrecord"
	"+whoami"
)
IUSE="doc caps +fastparser idn libidn2 systemd +utils ${KNOT_MODULES[@]}"

RDEPEND="
	>=dev-db/lmdb-0.9.15
	dev-libs/libedit
	>=dev-libs/userspace-rcu-0.5.4
	dev-python/lmdb
	>=net-libs/gnutls-3.3:=
	caps? ( >=sys-libs/libcap-ng-0.6.4 )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c
	)
	idn? (
		!libidn2? ( net-dns/libidn )
		libidn2? ( >=net-dns/libidn2-2.0.0 )
	)
	systemd? ( >=sys-apps/systemd-229 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local u
	local my_conf=()
	for u in "${KNOT_MODULES[@]#+}"; do
		my_conf+=("$(use_with $u module-$u)")
	done

	econf \
		--with-storage="${EPREFIX}/var/lib/${PN}" \
		--with-rundir="${EPREFIX}/var/run/${PN}" \
		$(use_enable fastparser) \
		$(use_enable dnstap) \
		$(use_enable doc documentation) \
		$(use_enable utils utilities) \
		--enable-systemd=$(usex systemd) \
		$(use_with idn libidn) \
		"${my_conf[@]}"
}

src_compile() {
	default

	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )
	fi
}

src_test() {
	emake check
}

src_install() {
	default

	rmdir "${D}var/run/${PN}" "${D}var/run/" || die
	keepdir /var/lib/${PN}

	newinitd "${FILESDIR}/knot.init" knot
	if use systemd; then
		systemd_newunit "${FILESDIR}/knot-1.service" knot.service
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	enewgroup knot 53
	enewuser knot 53 -1 /var/lib/knot knot
}
