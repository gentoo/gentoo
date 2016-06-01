# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit apache-module

MY_P="${PN/h2/http2}-${PV}"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/icing/mod_h2.git"
	inherit git-2
else
	SRC_URI="https://github.com/icing/mod_h2/releases/download/v${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="HTTP/2 module for Apache"
HOMEPAGE="https://github.com/icing/mod_h2"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ssl"

RDEPEND=">=net-libs/nghttp2-1.0
	>=www-servers/apache-2.4.20[-apache2_modules_http2,ssl?]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

need_apache2_4

src_configure() {
	econf \
		--docdir='$(datarootdir)'/doc/${PF} \
		--disable-werror
}

src_compile() {
	default
}

src_install() {
	default

	APACHE2_MOD_DEFINE="HTTP2"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/mod_http2.conf" "41_mod_http2.conf"
}
