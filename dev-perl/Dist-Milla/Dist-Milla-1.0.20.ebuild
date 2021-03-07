# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=v1.0.20
inherit perl-module

DESCRIPTION="Distribution builder, Opinionated but Unobtrusive"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/Dist-Zilla-6.0.0
	dev-perl/Dist-Zilla-Plugin-CheckChangesHasContent
	>=dev-perl/Dist-Zilla-Plugin-CopyFilesFromBuild-0.163.40
	dev-perl/Dist-Zilla-Plugin-CopyFilesFromRelease
	>=dev-perl/Dist-Zilla-Plugin-Git-Contributors-0.9.0
	>=dev-perl/Dist-Zilla-Plugin-Git-2.12.0
	dev-perl/Dist-Zilla-Plugin-GithubMeta
	>=dev-perl/Dist-Zilla-Plugin-LicenseFromModule-0.50.0
	dev-perl/Dist-Zilla-Plugin-ModuleBuildTiny
	>=dev-perl/Dist-Zilla-Plugin-NameFromDirectory-0.40.0
	>=dev-perl/Dist-Zilla-Plugin-Prereqs-FromCPANfile-0.60.0
	dev-perl/Dist-Zilla-Plugin-ReadmeAnyFromPod
	dev-perl/Dist-Zilla-Plugin-ReadmeFromPod
	>=dev-perl/Dist-Zilla-Plugin-ReversionOnRelease-0.40.0
	dev-perl/Dist-Zilla-Plugin-StaticInstall
	dev-perl/Dist-Zilla-Plugin-Test-Compile
	dev-perl/Dist-Zilla-Plugin-VersionFromMainModule
	dev-perl/Dist-Zilla-Config-Slicer
	dev-perl/Dist-Zilla-Role-PluginBundle-PluginRemover
	>=dev-perl/Module-CPANfile-0.902.500
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
