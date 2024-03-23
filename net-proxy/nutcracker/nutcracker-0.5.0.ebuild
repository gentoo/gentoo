# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A fast, light-weight proxy for Memcached and Redis. (Twitter's Twemproxy)"
HOMEPAGE="https://github.com/twitter/twemproxy"
SRC_URI="https://github.com/twitter/twemproxy/releases/download/${PV}/twemproxy-${PV}.tar.gz"
S="${WORKDIR}/twemproxy-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=">=dev-libs/libyaml-0.2.5"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Let's use system libyaml
	"${FILESDIR}"/${PN}-0.5.0-use-system-libyaml.patch
	"${FILESDIR}"/${PN}-0.5.0-configure-bashism.patch
	"${FILESDIR}"/${PN}-0.5.0-md5_signature-lto-mismatch.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use debug)
}

src_install() {
	default

	insinto /etc/nutcracker
	newins conf/nutcracker.yml nutcracker.yml.example

	newconfd "${FILESDIR}/nutcracker.confd.2" nutcracker
	newinitd "${FILESDIR}/nutcracker.initd.2" nutcracker

	if use doc; then
		dodoc -r notes
	fi
}
