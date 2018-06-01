# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Transparent SSL/TLS interception"
HOMEPAGE="http://www.roe.ch/SSLsplit"

LICENSE="BSD-2"
SLOT="0"
IUSE="elibc_musl test"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/droe/${PN}"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/droe/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	elibc_musl? ( sys-libs/fts-standalone )
	dev-libs/libevent[ssl,threads]
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_prepare() {
	default

	use elibc_musl && append-libs "-lfts"

	sed -i 's/-D_FORTIFY_SOURCE=2 //g' GNUmakefile || die
	sed -i 's/\<FEATURES\>/SSLSPLIT_FEATURES/g' GNUmakefile version.c || die
	sed -i '/opts_suite/d' main.t.c || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc AUTHORS.md NEWS.md README.md
}
