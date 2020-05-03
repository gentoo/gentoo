# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	GITHUB_USER=miyagawa
	GITHUB_REPO=cpanminus
	EGIT_REPO_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
	EGIT_BRANCH="devel"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	VCS_ECLASS="git-r3"
else
	DIST_AUTHOR=MIYAGAWA
	DIST_VERSION=1.7044
	KEYWORDS="amd64 ~ppc x86"
fi
inherit perl-module ${VCS_ECLASS}

DESCRIPTION="Get, unpack, build and install modules from CPAN"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

GIT_DEPENDS="
	dev-perl/Dist-Milla
	dev-perl/Dist-Zilla
	dev-perl/Dist-Zilla-Plugin-Run
	dev-perl/Perl-Version
	dev-perl/App-FatPacker
	dev-perl/Module-Install
	dev-perl/Module-Signature
	dev-perl/Perl-Strip
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
[[ ${PV} == 9999 ]] && BDEPEND+=" ${GIT_DEPENDS}"

dzil_env_setup() {
	# NextRelease noise :(
	mkdir -p ~/.dzil/
	local user="$(whoami)"
	local host="$(hostname)"
	printf '[%%User]\nname = %s\nemail = %s' "${user}" "${user}@${host}" >> ~/.dzil/config.ini
}
dzil_to_distdir() {
	local dzil_root dest has_missing modname dzil_version
	dzil_root="$1"
	dest="$2"

	cd "${dzil_root}" || die "Can't enter git workdir '${dzil_root}'";

	dzil_env_setup

	dzil_version="$(dzil version)" || die "Error invoking 'dzil version'"
	einfo "Generating CPAN dist with ${dzil_version}"

	has_missing=""

	einfo "Checking dzil authordeps"
	while IFS= read -d $'\n' -r modname; do
		if [[ -z "${has_missing}" ]]; then
		has_missing=1
			eerror "'dzil authordeps' indicates missing build dependencies"
			eerror "These will prevent building, please report a bug"
			eerror "Missing:"
		fi
		eerror "  ${modname}"
	done < <( dzil authordeps --missing --versions )

	[[ -z "${has_missing}" ]] || die "Satisfy all missing authordeps first"

	einfo "Checking dzil build deps"
	while IFS= read -d $'\n' -r modname; do
		if [[ -z "${has_missing}" ]]; then
			has_missing=1
			ewarn "'dzil listdeps' indicates missing build dependencies"
			ewarn "These may prevent building, please report a bug if they do"
			ewarn "Missing:"
		fi
		ewarn "  ${modname}"
	done < <( dzil listdeps --missing --versions --author )

	einfo "Generating release"
	dzil build --notgz --in "${dest}" || die "Unable to build CPAN dist in '${dest}'"
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		"${VCS_ECLASS}"_src_unpack
		mkdir -p "${S}" || die "Can't make ${S}"
	else
		default
	fi
}

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		# Uses git sources in WORKDIR/rex-git
		# to generate a CPAN-style tree in ${S}
		# before letting perl-module.eclass do the rest
		dzil_to_distdir "${EGIT_CHECKOUT_DIR}/App-cpanminus" "${S}"
	fi
	cd "${S}" || die "Can't enter build dir"
	perl-module_src_prepare
}
