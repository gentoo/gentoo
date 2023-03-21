# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A really tiny cross-platform proxy servers set"
HOMEPAGE="
	https://3proxy.ru/
	https://github.com/3proxy/3proxy/
"
SRC_URI="https://github.com/3proxy/3proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/${P}-function-pointer-fix.patch"
)

DOCS=( README cfg )
HTML_DOCS=( doc/html/. )

src_prepare() {
	default
	tc-export CC
	cp Makefile.Linux Makefile || die
}

src_install() {
	local x

	pushd bin >/dev/null || die
	dolib.so *.so
	dobin 3proxy
	for x in ftppr mycrypt pop3p proxy smtpp socks tcppm udppm; do
		newbin ${x} ${PN}-${x}
		[[ -f "${S}"/man/${x}.8 ]] && newman "${S}"/man/${x}.8 ${PN}-${x}.8
	done
	popd >/dev/null

	doman man/3proxy*.[38]

	einstalldocs
}
