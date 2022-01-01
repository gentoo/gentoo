# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/dlundquist/sniproxy.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/dlundquist/sniproxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Proxies incoming HTTP and TLS connections based on the hostname"
HOMEPAGE="https://github.com/dlundquist/sniproxy"

LICENSE="BSD-2"
SLOT="0"
IUSE="+dns +largefile rfc3339 test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/sniproxy
	acct-user/sniproxy
	dev-libs/libev
	>=dev-libs/libpcre-3
	dns? ( net-libs/udns )"
DEPEND="${RDEPEND}
	test? ( net-misc/curl )"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	eautoreconf

	sed -i "/user/s/daemon/sniproxy/" debian/sniproxy.conf || die "Unable to replace configuration"
	sed -i "/create/s/daemon/sniproxy/" debian/logrotate.conf || die "Unable to replace logrotate configuration"
}

src_configure() {
	local my_conf=(
		$(use_enable dns)
		$(use_enable largefile)
		$(use_enable rfc3339 rfc3339-timestamps)
	)

	econf "${my_conf[@]}"
}

src_test() {
	emake -j1 check
}

src_install() {
	default

	newinitd "${FILESDIR}/sniproxy.init" sniproxy

	insinto /etc/sniproxy
	doins debian/sniproxy.conf

	keepdir /var/log/sniproxy

	insinto /etc/logrotate.d
	newins debian/logrotate.conf sniproxy

	dodoc ARCHITECTURE.md AUTHORS README.md
	doman man/sniproxy.8
	doman man/sniproxy.conf.5
}
