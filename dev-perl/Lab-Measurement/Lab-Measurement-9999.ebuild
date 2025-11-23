# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_EXAMPLES=( "examples/*" )

if [[ "${PV}" != "9999" ]]; then
	DIST_VERSION=${PV%.0}
	DIST_AUTHOR=AKHUETTEL
	KEYWORDS="~amd64"
	inherit perl-module
else
	EGIT_REPO_URI="https://github.com/lab-measurement/Lab-Measurement.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-git"
	inherit perl-module git-r3
fi

DESCRIPTION="Measurement control and automation with Perl"
HOMEPAGE="https://www.labmeasurement.de"

SLOT="0"

DZIL_PLUGINS=( Git PodWeaver AuthorsFromGit RPM Test-ReportPrereqs )

RDEPEND="
	dev-perl/Class-ISA
	>=dev-perl/Class-Method-Modifiers-2.110.0
	>=dev-perl/Clone-0.310.0
	>=dev-perl/Exception-Class-1.0.0
	dev-perl/Hook-LexWrap
	>=dev-perl/IO-Socket-Timeout-0.320.0
	dev-perl/List-MoreUtils
	dev-perl/Math-Round
	>=virtual/perl-Module-Load-0.260.0
	>=dev-perl/Moose-2.121.300
	>=dev-perl/MooseX-Params-Validate-0.180.0
	dev-perl/MooseX-StrictConstructor
	dev-perl/Net-RFC3161-Timestamp
	>=dev-perl/PDL-2.7.0
	dev-perl/PDL-Graphics-Gnuplot
	dev-perl/PDL-IO-CSV
	>=dev-perl/Role-Tiny-1.3.4
	dev-perl/Statistics-Descriptive
	>=dev-perl/TermReadKey-2.300.0
	dev-perl/Text-Diff
	dev-perl/Time-Monotonic
	>=dev-perl/Try-Tiny-0.220.0
	>=dev-perl/YAML-LibYAML-0.410.0
	>=dev-perl/namespace-autoclean-0.200.0
	sci-visualization/gnuplot
	dev-perl/Lab-VXI11
	dev-perl/USB-TMC
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/File-Slurper
		dev-perl/Test-Fatal
		dev-perl/Test-File
		dev-perl/Text-Diff
		dev-perl/aliased
	)
"

if [[ "${PV}" == "9999" ]]; then
	DEPEND="${DEPEND}
		dev-perl/Dist-Zilla"
	for dzp in "${DZIL_PLUGINS[@]}" ; do
		DEPEND="${DEPEND}
		dev-perl/Dist-Zilla-Plugin-${dzp}"
	done
fi

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
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
		dzil_to_distdir "${EGIT_CHECKOUT_DIR}" "${S}"
	fi
	cd "${S}" || die "Can't enter build dir"
	perl-module_src_prepare
}
