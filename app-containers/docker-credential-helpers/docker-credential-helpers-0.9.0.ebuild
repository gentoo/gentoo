# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Suite of programs to use native stores to keep Docker credentials safe"
HOMEPAGE="https://github.com/docker/docker-credential-helpers"
SRC_URI="https://github.com/docker/docker-credential-helpers/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="keyring pass"
REQUIRED_USE="|| ( keyring pass )"
RESTRICT="test"

DEPEND="keyring? ( app-crypt/libsecret )"
RDEPEND="${DEPEND}
	pass? ( app-admin/pass )
"

src_compile() {
	local mymakeflags=(
		VERSION="${PV}"
		REVISION="v${PV}"
	)
	use keyring && mymakeflags+=( secretservice )
	use pass && mymakeflags+=( pass )
	emake -j1 "${mymakeflags[@]}"
}

src_install() {
	dobin bin/build/*
	dodoc MAINTAINERS README.md
}

pkg_postinst() {
	if use keyring; then
		elog "For keyring/kwallet add:\n"
		elog '		"credStore": "secretservice"'"\n"
	fi
	if use pass; then
		elog "For 'pass' add:\n"
		elog '		"credStore": "pass"'"\n"
	fi
	elog "to your ~/.docker/config.json"
}
