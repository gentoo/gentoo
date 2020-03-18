# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 go-module

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"

EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/aerc"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="notmuch"

BDEPEND=">=app-text/scdoc-1.9.7"
DEPEND="notmuch? ( net-mail/notmuch:= )"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	use notmuch && export GOFLAGS="-tags=notmuch"
	emake PREFIX="${EPREFIX}/usr"
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
}
