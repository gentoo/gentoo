# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

KEYWORDS="~amd64"
EGO_PN=github.com/docker/swarm
EGIT_COMMIT="527a849cc6b8297690f478905083fc77951da2a7"
MY_PN=classicswarm
SRC_URI="https://github.com/docker/classicswarm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Swarm Classic: a container clustering system"
HOMEPAGE="https://docs.docker.com/swarm"
LICENSE="Apache-2.0 CC-BY-SA-4.0 BSD BSD-2 ISC MIT MPL-2.0 WTFPL-2"
SLOT="0"
IUSE=""
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# It would require internet access to run `go mod vendor`, so
	# generate approximate go.mod and vendor/modules.txt from the
	# content of vendor.conf. Use a dummy vendor_version that is
	# good enough for go to recognize as a valid version.
	rm -f go.mod vendor/modules.txt || die
	local x vendor_version=v1.0.0
	printf -- 'module %s\n' "${EGO_PN}" >> go.mod || die
	printf -- 'go 1.14\n' >> go.mod || die
	printf -- 'require (\n' >> go.mod || die
	while read -r x; do
		printf -- '\t%s %s\n' "${x}" "${vendor_version}" >> go.mod || die
		printf -- '# %s %s\n' "${x}" "${vendor_version}" >> vendor/modules.txt || die
		printf -- '## explicit\n' >> vendor/modules.txt || die
		printf -- '%s\n' "${x}" >> vendor/modules.txt || die
	done < <(grep -Eo "^[^#[:space:]]+" vendor.conf)
	printf -- ')\n' >> go.mod || die
	default
}

src_compile() {
	GOBIN="${S}/bin" \
		go install -v -work -x -mod=vendor -x \
		-ldflags "-w -X github.com/docker/swarm/version.GITCOMMIT=${EGIT_COMMIT} \
		-X github.com/docker/swarm/version.BUILDTIME=$(date -u +%FT%T%z)" \
		./... || die
}

src_install() {
	dobin bin/swarm
	dosym swarm /usr/bin/docker-swarm
	dodoc CHANGELOG.md CONTRIBUTING.md logo.png README.md
}
