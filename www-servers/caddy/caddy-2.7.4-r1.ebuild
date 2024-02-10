# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module systemd shell-completion

DESCRIPTION="Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/caddyserver/caddy.git"
else
	SRC_URI="https://github.com/caddyserver/caddy/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
	SRC_URI+=" https://github.com/caddyserver/dist/archive/refs/tags/v${PV}.tar.gz -> ${P}-docs.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
fi

LICENSE="Apache-2.0 BSD ECL-2.0 MIT CC0-1.0"
SLOT="0"
RESTRICT="test"
RDEPEND="
	acct-user/http
	acct-group/http"
DEPEND="${RDEPEND}"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/"${PN}"
)

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		# unpack code
		git-r3_src_unpack

		# unpack docs and misc
		EGIT_REPO_URI="https://github.com/caddyserver/dist.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/dist-${PV}"
		git-r3_src_unpack

		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_prepare(){
	default
	sed -i -e "s|User=caddy|User=http|g;" ../dist-"${PV}"/init/*service || die
	sed -i -e "s|Group=caddy|Group=http|g;" ../dist-"${PV}"/init/*service || die
}

src_compile() {
	ego build ./cmd/caddy
	for sh in bash fish zsh; do
		./caddy completion "${sh}" > completion."${sh}" || die
	done
	./caddy manpage -o manpages || die
}

src_install() {
	default

	dobin "${PN}"
	insinto /etc/"${PN}"
	newins ../dist-"${PV}"/config/Caddyfile Caddyfile.example
	systemd_dounit ../dist-"${PV}"/init/*.service
	newinitd "${FILESDIR}/initd" "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" "${PN}"
	insinto /usr/share/"${PN}"
	doins ../dist-"${PV}"/welcome/index.html

	newbashcomp completion.bash "${PN}"
	newfishcomp completion.fish "${PN}".fish
	newzshcomp completion.zsh _"${PN}"
	newdoc ../dist-"${PV}"/init/README.md systemd-services-README.md
	doman manpages/*
}

pkg_postinst() {
	fcaps_pkg_postinst
}
