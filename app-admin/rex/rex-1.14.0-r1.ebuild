# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	GITHUB_USER=RexOps
	GITHUB_REPO=Rex
	EGIT_REPO_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	VCS_ECLASS="git-r3"
else
	# This is intentional to stop perl-module.eclass doing magic things when it
	# shouldn't. Like making ${S} contain "Rex" when the git clone has "rex"
	# Also prevents perl-module.eclass provisioning SRC_URI
	DIST_AUTHOR=FERKI
	DIST_NAME=Rex
	KEYWORDS="~amd64 ~x86"
fi
inherit bash-completion-r1 perl-module ${VCS_ECLASS}

DESCRIPTION="(R)?ex, the friendly automation framework"
HOMEPAGE="https://metacpan.org/dist/Rex https://www.rexify.org"

SLOT="0"
IUSE="minimal test"
RESTRICT="!test? ( test )"

DZIL_DEPENDS="
	dev-perl/Dist-Zilla
	dev-perl/Dist-Zilla-Plugin-CheckExtraTests
	dev-perl/Dist-Zilla-Plugin-ContributorsFile
	dev-perl/Dist-Zilla-Plugin-Git
	dev-perl/Dist-Zilla-Plugin-Git-Contributors
	dev-perl/Dist-Zilla-Plugin-MakeMaker-Awesome
	dev-perl/Dist-Zilla-Plugin-Meta-Contributors
	dev-perl/Dist-Zilla-Plugin-MetaProvides-Package
	dev-perl/Dist-Zilla-Plugin-NextVersion-Semantic
	dev-perl/Dist-Zilla-Plugin-OSPrereqs
	dev-perl/Dist-Zilla-Plugin-OurPkgVersion
	dev-perl/Dist-Zilla-Plugin-Run
	dev-perl/Software-License
"
RDEPEND="
	!minimal? (
		dev-perl/DBI
		dev-perl/Expect
		dev-perl/IPC-Shareable
		dev-perl/XML-LibXML
	)
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	dev-perl/Data-Validate-IP
	dev-perl/Devel-Caller
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	virtual/perl-Exporter
	virtual/perl-File-Spec
	dev-perl/HTTP-Message
	dev-perl/Hash-Merge
	virtual/perl-IO
	dev-perl/IO-String
	dev-perl/IO-Tty
	dev-perl/JSON-MaybeXS
	virtual/perl-MIME-Base64
	dev-perl/Net-OpenSSH
	dev-perl/Net-SFTP-Foreign
	>=virtual/perl-Scalar-List-Utils-1.450.0
	dev-perl/Parallel-ForkManager
	dev-perl/Sort-Naturally
	dev-perl/String-Escape
	virtual/perl-Storable
	dev-perl/TermReadKey
	virtual/perl-Test-Simple
	dev-perl/Text-Glob
	virtual/perl-Text-Tabs+Wrap
	virtual/perl-Time-HiRes
	dev-perl/URI
	dev-perl/XML-Simple
	dev-perl/libwww-perl
	dev-perl/YAML
	virtual/perl-version
"
# NB: would add test? !minimal? Test-mysqld, but I can't get that to work
BDEPEND="
	${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	>=virtual/perl-ExtUtils-MakeMaker-7.110.100
	>=dev-perl/File-ShareDir-Install-0.60.0
	virtual/perl-Module-Metadata
	test? (
		!minimal? (
			dev-perl/File-LibMagic
		)
		virtual/perl-File-Temp
		dev-perl/Sub-Override
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Output
		dev-perl/Test-UseAllModules
		virtual/perl-autodie
	)
"

[[ ${PV} == 9999 ]] && BDEPEND+=" ${DZIL_DEPENDS}"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		"${VCS_ECLASS}"_src_unpack
		mkdir -p "${S}" || die "Can't make ${S}"
	else
		default
	fi
}

dzil_src_prep() {
	einfo "Patching dist.ini"

	# This block of sed invocations removes all plugins that aren't
	# useful for users to have on Gentoo, because all of them are
	# conditional and subjective style checks, which don't indicate
	# a real issue for users, and paying the price of their dependencies is undesired.

	# The {N;d} trick adds the [n]ext line after the match to the pattern-space
	# so that the final [d]elete deletes the next line too. Can be expanded for each
	# line, ie: {N;N;N;d} deletes 3 lines after the match as well as the match.
	sed -e '/^\[Test::Kwalitee\]/d' \
		-e '/^\[PodSyntaxTests\]/d' \
		-e '/^Perl::Critic::Freenode =/d' \
		-e '/^Perl::Critic::TooMuchCode =/d' \
		-e '/^Test::Kwalitee =/d' \
		-e '/^Test::PerlTidy =/d' \
		-e '/^Test::Pod =/d' \
		-e '/^\[Test::CPAN::Changes\]/{N;d}' \
		-e '/^\[OptionalFeature/,/^$/d' \
		-e '/^\[Test::MinimumVersion\]/{N;d}' \
		-i dist.ini || die "Can't patch dist.ini"

	# Removals/additions have to be tracked by git or dzil build fails
	# Spurious warning during src_prepare
	git rm -f xt/author/critic-progressive.t || die "Can't rm author/critic-progressive.t"
	# Spurious warning during src_prepare
	git rm -f xt/author/perltidy.t || die "Can't rm author/perltidy.t"
}
dzil_env_setup() {
	# NextRelease noise :(
	mkdir -p ~/.dzil/ || die "mkdir -p ~/.dzil/ failed"
	local user="$(whoami)"
	local host="$(hostname)"
	printf '[%%User]\nname = %s\nemail = %s' "${user}" "${user}@${host}" >> ~/.dzil/config.ini

}
dzil_to_distdir() {
	local dzil_root dest has_missing modname dzil_version
	dzil_root="$1"
	dest="$2"

	cd "${dzil_root}" || die "Can't enter git workdir '${dzil_root}'";

	S="${dzil_root}" dzil_src_prep
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

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		# Uses git sources in WORKDIR/rex-git
		# to generate a CPAN-style tree in ${S}
		# before letting perl-module.eclass do the rest
		dzil_to_distdir "${EGIT_CHECKOUT_DIR}" "${S}"
	fi
	cd "${S}" || die "Can't enter build dir"

	# If you DIY installed Test::mysqld, but didn't patch
	# it to handle the fact on Gentoo, mysql_install_db is NOT in PATH
	# tests fail. So this test is patched out if mysql_install_db is not in PATH
	if perl_has_module "Test::mysqld" && ! type -P mysql_install_db >/dev/null; then
		perl_rm_files "t/db.t"
	fi
	perl-module_src_prepare
}

src_install() {
	newbashcomp "share/${PN}-tab-completion.bash" "${PN}"

	insinto /usr/share/zsh/site-functions
	newins "share/${PN}-tab-completion.zsh" "_${PN}"

	perl-module_src_install
}
