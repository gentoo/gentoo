# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Really tiny cross-platform proxy servers set"
HOMEPAGE="
	https://3proxy.org/
	https://github.com/3proxy/3proxy/
"
SRC_URI="https://github.com/3proxy/3proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~sparc x86"

RDEPEND="
	acct-group/3proxy
	acct-user/3proxy
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.5-gentoo.patch"
	"${FILESDIR}/${PN}-0.9.5-function-pointer-fix.patch"
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

	pushd bin || die
	dolib.so *.so
	dobin 3proxy
	for x in $(find -type f -executable ! -name '*.so' ! -name 3proxy -printf '%f\n'); do
		newbin ${x} ${PN}-${x}
		[[ -f "${S}"/man/${x}.8 ]] && newman "${S}"/man/${x}.8 ${PN}-${x}.8
	done
	popd || die

	diropts -m 0700 -o 3proxy -g 3proxy
	dodir /etc/3proxy

	insinto /etc/3proxy
	insopts -m 0600 -o 3proxy -g 3proxy
	doins cfg/3proxy.cfg.sample cfg/counters.sample

	newinitd "${FILESDIR}"/3proxy.initd 3proxy
	systemd_dounit scripts/3proxy.service

	doman man/3proxy*.[38]

	einstalldocs
}
