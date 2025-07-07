# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo shell-completion

DESCRIPTION="A highly customizable changelog generator"
HOMEPAGE="https://git-cliff.org/"
SRC_URI="
	https://github.com/orhun/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-crates.tar.xz
"

LICENSE="Apache-2.0 MIT BSD-2 BSD Boost-1.0 CDDL ISC MPL-2.0 Unicode-3.0
	Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	# disables tests against local (.)git repo
	"${FILESDIR}/${P}-disable_repo_tests.patch"
	# silences a "command not found" error (QA)
	"${FILESDIR}/${P}-silence_run_os_command_test.patch"
)

src_compile() {
	cargo_src_compile

	local target_dir="${S}/$(cargo_target_dir)"

	# generating man pages
	mkdir "${target_dir}/man"
	OUT_DIR="${target_dir}/man" "${target_dir}/"${PN}-mangen

	# generating completion scripts
	mkdir "${target_dir}/completion"
	OUT_DIR="${target_dir}/completion" "${target_dir}/"${PN}-completions
}

src_install() {
	local release_dir="${S}/$(cargo_target_dir)"

	insinto /usr/bin
	dobin "${release_dir}/"${PN}

	doman "${release_dir}/man/"${PN}.1

	newbashcomp "${release_dir}/completion/${PN}.bash" ${PN}
	newfishcomp "${release_dir}/completion/${PN}.fish" ${PN}

	einstalldocs
	dodoc -r "${S}"/examples/
}
