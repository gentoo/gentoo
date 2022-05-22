# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module xdg

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rjarry/aerc"
else
	SRC_URI="https://git.sr.ht/~rjarry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="notmuch"

DEPEND="notmuch? ( net-mail/notmuch:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	>=app-text/scdoc-1.9.7
	>=dev-lang/go-1.13
"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	LDFLAGS= \
	emake GOFLAGS="-mod=vendor $(usex notmuch "-tags=notmuch" "")" \
		PREFIX="${EPREFIX}/usr" VERSION=${PV}  all
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install
	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you want to allow your users to activate html email"
		elog "processing via w3m as shown in the tutorial, make sure you"
		elog "emerge net-proxy/dante and www-client/w3m"
	fi

	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test $v -lt 0.3.0-r1; then
			elog "The dependencies on net-proxy/dante and www-client/w3m"
			elog "have been removed since they are optional."
			elog "Please emerge them before the next --depclean if you"
			elog "need to use them."
		fi
	done
	xdg_pkg_postinst
}
