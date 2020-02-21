# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	GITHUB_USER=RexOps
	GITHUB_REPO=Rex
	EGIT_REPO_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
	EGIT_BRANCH="development-1.x"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	VCS_ECLASS="git-r3"
else
	# This is intentional to stop perl-module.eclass doing magic things when it
	# shouldn't. Like making ${S} contain "Rex" when the git clone has "rex"
	# Also prevents perl-module.eclass provisioning SRC_URI
	DIST_AUTHOR=JFRIED
	DIST_NAME=Rex
	KEYWORDS="~amd64 ~x86"
fi

inherit perl-module ${VCS_ECLASS}

DESCRIPTION="(R)?ex is a small script to ease the execution of remote commands"

SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DZIL_DEPENDS="
	dev-perl/Dist-Zilla
	dev-perl/Dist-Zilla-Plugin-MakeMaker-Awesome
	dev-perl/Dist-Zilla-Plugin-MetaProvides-Package
	dev-perl/Dist-Zilla-Plugin-OSPrereqs
	dev-perl/Dist-Zilla-Plugin-OurPkgVersion
	dev-perl/Dist-Zilla-Plugin-Test-MinimumVersion
	dev-perl/Dist-Zilla-Plugin-Test-Perl-Critic
"

RDEPEND="
	dev-perl/Data-Validate-IP
	dev-perl/DBI
	dev-perl/Devel-Caller
	dev-perl/Digest-HMAC
	dev-perl/Digest-SHA1
	dev-perl/Expect
	dev-perl/Hash-Merge
	dev-perl/IO-String
	dev-perl/IO-Tty
	dev-perl/IPC-Shareable
	dev-perl/JSON-XS
	dev-perl/List-MoreUtils
	dev-perl/Net-OpenSSH
	dev-perl/Net-SFTP-Foreign
	dev-perl/Parallel-ForkManager
	dev-perl/Sort-Naturally
	dev-perl/String-Escape
	dev-perl/TermReadKey
	dev-perl/Test-Deep
	dev-perl/Text-Glob
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
	dev-perl/libwww-perl
	dev-perl/YAML
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Digest-MD5
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	virtual/perl-Time-HiRes
"

DEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-UseAllModules
		virtual/perl-File-Temp
	)
"

[[ ${PV} == 9999 ]] && DEPEND+=" ${DZIL_DEPENDS}"

src_unpack() {
	if [[ $PV == 9999 ]]; then
		"${VCS_ECLASS}"_src_unpack
		mkdir -p "${S}" || die "Can't make ${S}"
	else
		default
	fi
}

dzil_to_distdir() {
	local dzil_root dest has_missing modname dzil_version
	dzil_root="$1"
	dest="$2"

	cd "${dzil_root}" || die "Can't enter git workdir '${dzil_root}'";

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

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		# Uses git sources in WORKDIR/rex-git
		# to generate a CPAN-style tree in ${S}
		# before letting perl-module.eclass do the rest
		dzil_to_distdir "${EGIT_CHECKOUT_DIR}" "${S}"
	fi
	cd "${S}" || die "Can't enter build dir"
	perl-module_src_prepare
}
