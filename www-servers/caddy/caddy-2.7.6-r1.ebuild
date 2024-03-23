# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module systemd shell-completion

DESCRIPTION="Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"

if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/caddyserver/caddy.git"
else
	SRC_URI="
		https://github.com/caddyserver/caddy/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~zmedico/dist/${PF}-deps.tar.xz
		https://github.com/caddyserver/dist/archive/refs/tags/v${PV}.tar.gz -> ${P}-docs.tar.gz
"
	KEYWORDS="amd64 arm64 ~loong ~riscv"
fi

# MAIN
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD ECL-2.0 MIT CC0-1.0"
SLOT="0"

IUSE='events-handlers-exec'
RESTRICT="test"

RDEPEND="
	acct-user/http
	acct-group/http"
DEPEND="${RDEPEND}"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/"${PN}"
)

PATCHES=(
	"${FILESDIR}"/remove-binary-altering-commands-2.7.5.patch
)

# takes a module as an only arg
add_custom_module() {
	local LINE_NO=$(grep -n 'plug in Caddy modules here' cmd/caddy/main.go | awk -F: '{print $1;}')
	sed -i -e "${LINE_NO:?}a \        _ \"$1\"" cmd/caddy/main.go || die
}

src_unpack() {
	if [[ "${PV}" == 9999* ]]; then
		# clone main git repo
		git-r3_src_unpack

		# get extra modules
		if use events-handlers-exec; then
			pushd "${P}"
			add_custom_module 'github.com/mholt/caddy-events-exec' || die
			ego get github.com/mholt/caddy-events-exec
			popd
		fi

		# clone dist repo (docs and misc)
		EGIT_REPO_URI="https://github.com/caddyserver/dist.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/dist-${PV}"
		git-r3_src_unpack

		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_prepare() {
	default
	sed -i -e "s|User=caddy|User=http|g;s|Group=caddy|Group=http|g;" ../dist-"${PV}"/init/*service || die

	if use events-handlers-exec && [[ "${PV}" != 9999* ]]; then
		add_custom_module 'github.com/mholt/caddy-events-exec' || die
		cat <<-EOF >> go.sum || die
			github.com/mholt/caddy-events-exec v0.0.0-20231121214933-055bfd2e8b82 h1:uRsPaFNQJRDrYcSsgnH0hFhCWFXfgB8QVH8yjX+u154=
			github.com/mholt/caddy-events-exec v0.0.0-20231121214933-055bfd2e8b82/go.mod h1:Y9JjT8YLxpmk7PeUkvsWAhzzRdC6rXP7QjAHiwmvjD0=
		EOF

		cat <<-EOF >> go.mod || die
			require (
					github.com/mholt/caddy-events-exec v0.0.0-20231121214933-055bfd2e8b82 // indirect
			)
		EOF
	fi
}

src_compile() {
	# https://github.com/caddyserver/caddy/blob/master/caddy.go#L843
	if [[ ${PV} == 9999* ]]; then
		local CUSTOM_VER="git-$(git rev-parse --short HEAD)"
	else
		local CUSTOM_VER="${PV}"
	fi

	ego build -ldflags "-X github.com/caddyserver/caddy/v2.CustomVersion=${CUSTOM_VER}" ./cmd/caddy
	local sh
	for sh in bash fish zsh; do
		./caddy completion "${sh}" > completion."${sh}" || die
	done
	./caddy manpage -o manpages || die
}

src_install() {
	default

	dobin "${PN}"
	insinto /etc/"${PN}"
	doins ../dist-"${PV}"/config/Caddyfile
	systemd_dounit ../dist-"${PV}"/init/*.service
	newinitd "${FILESDIR}"/initd-2.7.5 "${PN}"
	newconfd "${FILESDIR}"/confd-2.7.5 "${PN}"
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
