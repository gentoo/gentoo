# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}3"
MECK_PV="0.8.13"  # see rebar.config

inherit edo shell-completion

DESCRIPTION="A sophisticated build-tool for Erlang projects that follows OTP principles"
HOMEPAGE="https://www.rebar3.org/
	https://github.com/erlang/rebar3/"

SRC_URI="
	https://github.com/erlang/${MY_PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://repo.hex.pm/tarballs/meck-${MECK_PV}.tar
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0 MIT BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Note: /usr/bin/rebar is a ZIP archive of BEAM files so := is needed
# see #913601
RDEPEND="
	>=dev-lang/erlang-26.0:=[ssl]
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/rebar-3.27.0-rebar_ct_SUITE.patch" )

src_unpack() {
	unpack "${P}.gh.tar.gz"

	if use test; then
		mkdir -p "${S}/vendor/meck" || die "failed to create dir"
		tar -O -xf "${DISTDIR}/meck-${MECK_PV}.tar" contents.tar.gz \
			| tar -xzf - -C "${S}/vendor/meck"
		assert
	fi
}

src_configure() {
	unset MIX_REBAR3
	export REBAR_OFFLINE="1"

	default
}

src_compile() {
	edo escript ./bootstrap --offline
}

src_test() {
	local -a rebar_opts=( --verbose --readable true --dir ./apps/rebar/test/ )
	local -a suites=(
		# mock_git_resource mock_git_subdir_resource
		# rebar_compile_SUITE
		# rebar_ct_SUITE
		# rebar_deps_SUITE
		# rebar_dialyzer_SUITE
		# rebar_hooks_SUITE
		# rebar_install_deps_SUITE
		# rebar_pkg_SUITE rebar_pkg_alias_SUITE rebar_pkg_repos_SUITE
		# rebar_plugins_SUITE
		# rebar_profiles_SUITE
		# rebar_upgrade_SUITE
		# rebar_xref_SUITE
		mock_pkg_resource
		rebar_alias_SUITE
		rebar_as_SUITE
		rebar_compiler_dag_SUITE rebar_compiler_epp_SUITE rebar_compiler_format_SUITE
		rebar_completion_SUITE
		rebar_cover_SUITE
		rebar_dir_SUITE
		rebar_disable_app_SUITE
		rebar_discover_SUITE
		rebar_dist_utils_SUITE
		rebar_edoc_SUITE
		rebar_escriptize_SUITE
		rebar_eunit_SUITE
		rebar_file_utils_SUITE
		rebar_localfs_resource rebar_localfs_resource_v2
		rebar_lock_SUITE
		rebar_manifest_SUITE
		rebar_namespace_SUITE
		rebar_new_SUITE
		rebar_opts_parser_SUITE
		rebar_parallel_SUITE
		rebar_paths_SUITE
		rebar_release_SUITE
		rebar_resource_SUITE
		rebar_semver_SUITE
		rebar_src_dirs_SUITE
		rebar_templater_SUITE
		rebar_test_utils
		rebar_unlock_SUITE
		rebar_uri_SUITE
		rebar_utils_SUITE
	)

	local suites_failed=()
	local suites_pass="YES"
	local suite=""
	for suite in "${suites[@]}" ; do
		if ./rebar3 ct "${rebar_opts[@]}" --suite "${suite}" ; then
			einfo "The rebar test suite \"${suite}\" passed tests successfully"
		else
			eerror "The rebar test suite \"${suite}\" failed tests"
			suites_failed+=( "${suite}" )
			suites_pass="NO"
		fi
	done

	if [[ "${suites_pass}" == "NO" ]] ; then
		eerror "Failed test suites: ${suites_failed[*]}"
		die "Some rebar test suites failed! Please inspect the errors above."
	fi
}

src_install() {
	dobin ${MY_PN}
	dodoc rebar.config.sample
	doman manpages/${MY_PN}.1

	dobashcomp apps/rebar/priv/shell-completion/bash/${MY_PN}
	dozshcomp apps/rebar/priv/shell-completion/zsh/_${MY_PN}
	insinto /usr/share/fish/completion
	newins apps/rebar/priv/shell-completion/fish/${MY_PN}.fish ${MY_PN}

	# MIX_REBAR3: Used by elixir
	newenvd - 98rebar3 <<-EOF
	MIX_REBAR3=${EPREFIX}/usr/bin/${MY_PN}
EOF
}
