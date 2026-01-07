# Copyright 1999-2025 Gentoo Authors
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
		https://github.com/rahilarious/gentoo-distfiles/releases/download/${PF}/deps.tar.xz -> ${PF}-deps.tar.xz
		https://github.com/rahilarious/gentoo-distfiles/releases/download/${PF}/go-mod-sum.patch -> ${PF}-go-mod-sum.patch
		https://github.com/caddyserver/dist/archive/refs/tags/v${PV}.tar.gz -> ${P}-docs.tar.gz
"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
fi

# MAIN
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD ECL-2.0 MIT CC0-1.0"
SLOT="0"

IUSE='dynamicdns dns-alidns dns-azure dns-cloudflare dns-cloudns dns-digitalocean dns-duckdns dns-dynv6 dns-gandi dns-godaddy dns-googleclouddns dns-he dns-hetzner dns-huaweicloud dns-linode dns-mailinabox dns-namecheap dns-netcup dns-netlify dns-ovh dns-porkbun dns-powerdns dns-rfc2136 dns-route53 dns-vultr events-handlers-exec security webdav'
RESTRICT="test"

RDEPEND="
	acct-user/http
	acct-group/http"
DEPEND="${RDEPEND}"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/"${PN}"
)

# takes a module as an only arg
add_custom_module() {
	local LINE_NO=$(grep -n 'plug in Caddy modules here' cmd/caddy/main.go | awk -F: '{print $1;}' || die)
	sed -i -e "${LINE_NO:?}a \        _ \"$1\"" cmd/caddy/main.go || die
}

src_unpack() {
	declare -A MOOMODULES || die

	use dynamicdns && { MOOMODULES[ddns]="github.com/mholt/caddy-dynamicdns" || die ; }
	use events-handlers-exec && { MOOMODULES[exec]="github.com/mholt/caddy-events-exec" || die ; }
	use security && { MOOMODULES[sec]="github.com/greenpau/caddy-security" || die ; }
	use webdav && { MOOMODULES[webdav]="github.com/mholt/caddy-webdav" || die ; }

	# alphabetically sorted popular DNS providers plugins
	# more info on https://caddyserver.com/docs/modules/
	use dns-alidns && { MOOMODULES[alidns]="github.com/caddy-dns/alidns" || die ; }
	use dns-azure && { MOOMODULES[azure]="github.com/caddy-dns/azure" || die ; }
	use dns-cloudflare && { MOOMODULES[cloudflare]="github.com/caddy-dns/cloudflare" || die ; }
	use dns-cloudns && { MOOMODULES[cloudns]="github.com/caddy-dns/cloudns" || die ; }
	use dns-digitalocean && { MOOMODULES[do]="github.com/caddy-dns/digitalocean" || die ; }
	use dns-duckdns && { MOOMODULES[duck]="github.com/caddy-dns/duckdns" || die ; }
	use dns-dynv6 && { MOOMODULES[dynv6]="github.com/caddy-dns/dynv6" || die ; }
	use dns-gandi && { MOOMODULES[gandi]="github.com/caddy-dns/gandi" || die ; }
	use dns-godaddy && { MOOMODULES[godaddy]="github.com/caddy-dns/godaddy" || die ; }
	use dns-googleclouddns && { MOOMODULES[gcpdns]="github.com/caddy-dns/googleclouddns" || die ; }
	use dns-he && { MOOMODULES[he]="github.com/caddy-dns/he" || die ; }
	use dns-hetzner && { MOOMODULES[hetzner]="github.com/caddy-dns/hetzner" || die ; }
	use dns-huaweicloud && { MOOMODULES[huaweicloud]="github.com/caddy-dns/huaweicloud" || die ; }
	use dns-linode && { MOOMODULES[linode]="github.com/caddy-dns/linode" || die ; }
	use dns-mailinabox && { MOOMODULES[miabox]="github.com/caddy-dns/mailinabox" || die ; }
	use dns-namecheap && { MOOMODULES[namecheap]="github.com/caddy-dns/namecheap" || die ; }
	use dns-netcup && { MOOMODULES[netcup]="github.com/caddy-dns/netcup" || die ; }
	use dns-netlify && { MOOMODULES[netlify]="github.com/caddy-dns/netlify" || die ; }
	use dns-ovh && { MOOMODULES[ovh]="github.com/caddy-dns/ovh" || die ; }
	use dns-porkbun && { MOOMODULES[porkbun]="github.com/caddy-dns/porkbun" || die ; }
	use dns-powerdns && { MOOMODULES[powerdns]="github.com/caddy-dns/powerdns" || die ; }
	use dns-rfc2136 && { MOOMODULES[rfc]="github.com/caddy-dns/rfc2136" || die ; }
	use dns-route53 && { MOOMODULES[route53]="github.com/caddy-dns/route53" || die ; }
	use dns-vultr && { MOOMODULES[vultr]="github.com/caddy-dns/vultr" || die ; }

	export MY_MODULES="${MOOMODULES[@]}" || die

	if [[ "${PV}" == 9999* ]]; then
		# clone main git repo
		git-r3_src_unpack

		# get extra modules
		pushd "${P}" || die
		for moo in ${MY_MODULES}; do
			add_custom_module "${moo}"
			ego get "${moo}"
		done
		popd || die

		# clone dist repo (docs and misc)
		EGIT_REPO_URI="https://github.com/caddyserver/dist.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/dist-${PV}"
		git-r3_src_unpack

		go-module_live_vendor
	else
		default
	fi
}

src_prepare() {
	default
	sed -i -e "s|User=caddy|User=http|g;s|Group=caddy|Group=http|g;" ../dist-*/init/*service || die

	if [[ "${PV}" != 9999* ]]; then
		eapply "${DISTDIR}/${PF}"-go-mod-sum.patch

		for moo in ${MY_MODULES}; do
			add_custom_module "${moo}"
		done
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
	doins ../dist-*/config/Caddyfile
	systemd_dounit ../dist-*/init/*.service
	newinitd "${FILESDIR}"/initd-2.7.5 "${PN}"
	newconfd "${FILESDIR}"/confd-2.7.5 "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" "${PN}"
	insinto /usr/share/"${PN}"
	doins ../dist-*/welcome/index.html

	newbashcomp completion.bash "${PN}"
	newfishcomp completion.fish "${PN}".fish
	newzshcomp completion.zsh _"${PN}"
	newdoc ../dist-*/init/README.md systemd-services-README.md
	doman manpages/*
}
