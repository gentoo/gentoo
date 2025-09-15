# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
HOMEPAGE="https://pi-hole.net"
DESCRIPTION="A metapackage for Pi-hole dependencies."
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="
	app-admin/sudo
	app-alternatives/awk
	app-arch/unzip
	app-misc/ca-certificates
	app-misc/jq
	app-shells/bash-completion
	dev-util/dialog
	dev-vcs/git
	net-analyzer/openbsd-netcat
	net-dns/bind-tools
	net-dns/dnssec-root
	net-misc/curl
	net-misc/iputils
	sys-apps/grep
	sys-apps/iproute2
	sys-apps/lshw
	sys-devel/binutils
	sys-libs/libcap
	sys-process/procps
	sys-process/psmisc
	virtual/cron
"
