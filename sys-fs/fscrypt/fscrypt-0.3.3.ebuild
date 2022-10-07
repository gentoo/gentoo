# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module pam

DESCRIPTION="Tool for managing Linux filesystem encryption"
HOMEPAGE="https://github.com/google/fscrypt"
SRC_URI="
	https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz
"

# Apache-2.0: fscrypt, google/renameio
# BSD: golang/protobuf, rogpeppe/go-internal, golang/x/*
# BSD-2: pkg/errors
# MIT: BurntSushi/toml, kisielk/gotool, kr/*, urfave/cli, honnef.co/go/tools
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Remove-TestLoadSourceDevice.patch"
)

src_compile() {
	# Set GO_LINK_FLAGS to the empty string, as fscrypt strips the
	# binary by default. See bug #783780.
	emake GO_LINK_FLAGS=""
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		PREFIX="/usr" \
		PAM_MODULE_DIR="$(getpam_mod_dir)" \
		PAM_CONFIG_DIR= \
		install
	einstalldocs

	newpamd "${FILESDIR}/fscrypt.pam-config" fscrypt
}
