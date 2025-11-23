# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature xdg

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rjarry/aerc"
else
	SRC_URI="https://git.sr.ht/~rjarry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="notmuch"

COMMON_DEPEND="notmuch? ( net-mail/notmuch:= )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	>=app-text/scdoc-1.11.3
	>=dev-lang/go-1.24.3
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
	unset LDFLAGS
	emake GOFLAGS="$(usex notmuch "-tags=notmuch" "")" \
		PREFIX="${EPREFIX}/usr" VERSION=${PV}  all
}

src_install() {
	emake GOFLAGS="$(usex notmuch "-tags=notmuch" "")" \
		DESTDIR="${ED}" PREFIX="${EPREFIX}/usr" VERSION="${PV}" install
	einstalldocs
	dodoc CHANGELOG.md
}

src_test() {
	emake tests
}

pkg_postinst() {
	optfeature "html email processing as shown in the tutorial" "net-proxy/dante www-client/w3m"
	xdg_pkg_postinst
}
