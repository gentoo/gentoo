# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

declare -A GIT_CRATES=(
	[libnss]='https://github.com/petski/libnss-rs;f54bb532f9951b7c79959522a0ab0ccc7a8abe17;libnss-rs-%commit%/libnss'
)

RUST_MIN_VER="1.88.0"
inherit cargo readme.gentoo-r1

DESCRIPTION="NSS plugin for finding Docker containers by their ID or name"
HOMEPAGE="https://github.com/petski/nss-docker-ng"
SRC_URI="https://github.com/petski/nss-docker-ng/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 LGPL-3 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/patchelf"

QA_FLAGS_IGNORED="usr/lib.*/libnss_docker_ng.so.*"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS='
You must modify your name service switch lookup file to enable nss-docker-ng.
To do so, add 'docker_ng' to the hosts line in /etc/nsswitch.conf

An example hosts line looks like this:
	hosts:      docker_ng resolve [!UNAVAIL=return] files myhostname dns
'

src_prepare() {
	default

	# upstream patches libnss with a git fork
	local libnss_commit
	IFS=';' read -r _ libnss_commit _ <<< "${GIT_CRATES[libnss]}"
	sed -i -e "/^libnss = { git = /c\\libnss = { path = \"${WORKDIR}/libnss-rs-${libnss_commit}/libnss\" }" \
		Cargo.toml || die
}

src_install() {
	cd "$(cargo_target_dir)" || die
	patchelf --set-soname libnss_docker_ng.so.2 libnss_docker_ng.so || die
	mv libnss_docker_ng.so libnss_docker_ng.so.2 || die
	ln -s libnss_docker_ng.so.2 libnss_docker_ng.so || die
	dolib.so libnss_docker_ng.so*
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
