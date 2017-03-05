# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

DESCRIPTION="A really tiny cross-platform proxy servers set"
HOMEPAGE="http://www.3proxy.ru/"
SRC_URI="https://github.com/z3APA3A/3proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.8-gentoo.patch
)

DOCS=( README cfg )
HTML_DOCS=( doc/html/. )

src_prepare() {
	default
	cp Makefile.Linux Makefile || die
}

src_install() {
	local x

	pushd src >/dev/null || die
	dobin 3proxy
	for x in proxy socks ftppr pop3p tcppm udppm mycrypt dighosts icqpr smtpp; do
		newbin ${x} ${PN}-${x}
		[[ -f "${S}"/man/${x}.8 ]] && newman "${S}"/man/${x}.8 ${PN}-${x}.8
	done
	popd >/dev/null

	doman man/3proxy*.[38]

	einstalldocs
}
