# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "

RUST_MIN_VER="1.86"

inherit cargo greadme shell-completion systemd

DESCRIPTION="Shell history manager supporting encrypted synchronisation"
HOMEPAGE="https://atuin.sh https://github.com/atuinsh/atuin"
SRC_URI="https://github.com/atuinsh/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/atuin/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
# - openssl for ring crate
LICENSE+=" Apache-2.0 BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="+client +daemon server test +sync"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( client server )
	sync? ( client )
	test? ( client server sync )
"
DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}
	server? ( acct-user/atuin )
"
BDEPEND="test? ( dev-db/postgresql )"

QA_FLAGS_IGNORED="usr/bin/${PN}"

GREADME_DISABLE_AUTOFORMAT=1

DOCS=( CONTRIBUTING.md CONTRIBUTORS README.md )

src_configure() {
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	local myfeatures=(
		$(usev client)
		$(usev daemon)
		$(usev server)
		$(usev sync)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile

	ATUIN_BIN="$(cargo_target_dir)/${PN}"

	# Prepare shell completion generation
	mkdir completions || die
	local shell
	for shell in bash fish zsh; do
		"${ATUIN_BIN}" gen-completions \
					 -s ${shell} \
					 -o completions \
			|| die
	done

	if ! use client; then
		return 0
	fi

	mkdir shell-init || die
	for shell in bash fish zsh; do
		"${ATUIN_BIN}" init ${shell} > shell-init/${shell} || die
	done
}

src_test() {
	local postgres_dir="${T}"/postgres
	initdb "${postgres_dir}" || die

	local port=11123
	# -h '' --> only socket connections allowed.
	postgres -D "${postgres_dir}" \
			 -k "${postgres_dir}" \
			 -p "${port}" &
	local postgres_pid=${!}

	local timeout_secs=30
	timeout "${timeout_secs}" bash -c \
			'until printf "" >/dev/tcp/${0}/${1} 2>> "${T}/portlog"; do sleep 1; done' \
			localhost "${port}" || die "Timeout waiting for postgres port ${port} to become available"

	psql -h localhost -p "${port}" -d postgres <<-EOF || die "Failed to configure postgres"
	create database atuin;
	create user atuin with encrypted password 'pass';
	grant all privileges on database atuin to atuin;
	\connect atuin
	grant all on schema public to atuin;
	EOF

	# Subshell so that postgres_pid is in scope when the trap is executed.
	(
		cleanup() {
			kill "${postgres_pid}" || die "failed to send SIGTERM to postgres"
		}
		trap cleanup EXIT

		ATUIN_DB_URI="postgres://atuin:pass@localhost:${port}/atuin" cargo_src_test
	)
}

src_install() {
	dobin "${ATUIN_BIN}"

	if use server; then
		systemd_dounit "${FILESDIR}/atuin.service"
	fi

	dodoc -r "${DOCS[@]}"

	newbashcomp "completions/${PN}.bash" "${PN}"
	dozshcomp "completions/_${PN}"
	dofishcomp "completions/${PN}.fish"

	if use daemon; then
		systemd_douserunit "${FILESDIR}"/atuin-daemon.{service,socket}
	fi

	if ! use client; then
		return 0
	fi

	insinto "/usr/share/${PN}"
	doins -r shell-init

	# The following readme text is only relevant if USE=client.
	greadme_stdin <<-EOF
	Gentoo installs atuin's shell-init code under
	    /usr/share/atuin/shell-init/
	Therefore, instead of using, e.g., 'eval \"\$(atuin init zsh)\"' in
	your .zshrc you can simply put \"source /usr/share/atuin/shell-init/zsh\"
	there, which avoids the cost of forking a process.
EOF
}
