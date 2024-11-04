# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo readme.gentoo-r1

DESCRIPTION="Context-aware bash history search replacement (ctrl-r)"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://github.com/cantino/mcfly/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"
SRC_URI+="https://dev.gentoo.org/~arthurzam/distfiles/app-shells/${PN}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/mcfly"

src_install() {
	cargo_src_install

	insinto /usr/share/${PN}
	doins ${PN}.{bash,fish,zsh}

	# create README.gentoo
	local DISABLE_AUTOFORMATTING="yes"
	local DOC_CONTENTS=\
"To start using ${PN}, add the following to your shell:

~/.bashrc
eval \"\$(mcfly init bash)\"

~/.config/fish/config.fish
mcfly init fish | source

~/.zsh
eval \"\$(mcfly init zsh)\""
	readme.gentoo_create_doc

	einstalldocs
}

pkg_postinst() {
	readme.gentoo_print_elog
}
