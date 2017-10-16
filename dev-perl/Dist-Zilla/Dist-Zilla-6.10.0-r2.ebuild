# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=6.010
inherit perl-module

DESCRIPTION="distribution builder; installer not included!"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"

PATCHES=(
	"${FILESDIR}/${P}-perl526.patch"
)
## CPAN->Gentoo resolution map for grepping in case upstream split a dep
# breaks: Dist::Zilla::App::Command::stale -> Dist-Zilla-Plugin-PromptIfStale
# DZA:Command::xtest -> DZP:CheckExtraTests
# DZP:Author::Plicease::Tests -> DZPB::Author::Plicease
X_BREAKS="
	!<dev-perl/Dist-Zilla-Plugin-PromptIfStale-0.40.0
	!<=dev-perl/Dist-Zilla-App-Command-update-0.40.0
	!<dev-perl/Dist-Zilla-Plugin-CheckExtraTests-0.29.0
	!<=dev-perl/Dist-Zilla-PluginBundle-Author-Plicease-2.20.0
	!<dev-perl/Dist-Zilla-Plugin-CopyFilesFromBuild-0.161.230
	!<=dev-perl/Dist-Zilla-Plugin-CopyFilesFromBuild-Filtered-0.1.0
	!<=dev-perl/Dist-Zilla-Plugin-Git-2.36.0
	!<=dev-perl/Dist-Zilla-Plugin-Keywords-0.6.0
	!<dev-perl/Dist-Zilla-Plugin-MakeMaker-Awesome-0.220.0
	!<=dev-perl/Dist-Zilla-Plugin-NameFromDirectory-0.30.0
	!<=dev-perl/Dist-Zilla-Plugin-PodWeaver-4.6.0
	!<=dev-perl/Dist-Zilla-Plugin-Prereqs-AuthorDeps-0.5.0
	!<dev-perl/Dist-Zilla-Plugin-ReadmeAnyFromPod-0.161.170
	!<=dev-perl/Dist-Zilla-Plugin-Run-0.35.0
	!<=dev-perl/Dist-Zilla-Plugin-Test-CheckDeps-0.13.0
	!<=dev-perl/Dist-Zilla-Plugin-Test-Version-1.50.0
	!<=dev-perl/Dist-Zilla-Plugin-TrialVersionComment-0.3.0
"
# r: App::Cmd::Command::version -> App-Cmd-0.321
# r: App::Cmd::Setup  -> App-Cmd
# r: App::Cmd::Tester -> App-Cmd
# r: App::Cmd::Tester::CaptureExternal -> App-Cmd 0.314
# r: CPAN::Meta::Converter -> CPAN-Meta
# r: CPAN::Meta::Merge -> CPAN-Meta 2.142060
# r: CPAN::Meta::Prereqs -> CPAN-Meta
# r: CPAN::Meta::Validator -> CPAN-Meta
# r: Config::INI::Reader -> Config-INI
# r: Config::MVP::Assembler -> Config-MVP
# r: Config::MVP::Assembler::WithBundles -> Config-MVP
# r: Config::MVP::Reader -> Config-MVP
# r: Config::MVP::Reader::Findable::ByExtension -> Config-MVP 1.101450
# r: Config::MVP::Reader::Finder -> Config-MVP 0.092990
# r: Config::MVP::Section -> Config-MVP
# r: List::Util -> Scalar-List-Utils
# r: Mixin::Linewise::Readers -> Mixin-Linewise
# r: Moose::Role -> Moose
# r: Moose::Util::TypeConstraints -> Moose
# r: MooseX::Types::Moose -> MooseX-Types
# r: PPI::Document -> PPI
# r: Scalar::Util -> Scalar-List-Utils
# r: Software::LicenseUtils -> Software-License
# r: Sub::Exporter::Util -> Sub-Exporter
# r: Term::ReadKey -> TermReadKey
# r: Text::Template -> text-template
# r: strict, warnings -> perl

# NB: PPI::XS is suggested by Dist-Zilla, but upstream of
#     PPI say PPI::XS presently doesn't do anything useful,
#     so the optional useflag and the dependency are skipped.
RDEPEND="
	${X_BREAKS}
	!minimal? (
		>=dev-perl/Archive-Tar-Wrapper-0.150.0
		>=dev-perl/Data-OptList-0.110.0
		dev-perl/Term-ReadLine-Gnu
	)
	>=dev-perl/App-Cmd-0.330.0
	virtual/perl-Archive-Tar
	>=virtual/perl-CPAN-Meta-2.142.60
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	>=dev-perl/CPAN-Uploader-0.103.4
	virtual/perl-Carp
	>=dev-perl/Class-Load-0.170.0
	dev-perl/Config-INI
	>=dev-perl/Config-MVP-2.200.10
	>=dev-perl/Config-MVP-Reader-INI-2.101.461
	virtual/perl-Data-Dumper
	>=dev-perl/Data-Section-0.200.2
	>=dev-perl/DateTime-0.440.0
	virtual/perl-Digest-MD5
	virtual/perl-Encode
	>=virtual/perl-ExtUtils-Manifest-1.660.0
	dev-perl/File-Copy-Recursive
	dev-perl/File-Find-Rule
	dev-perl/File-HomeDir
	virtual/perl-File-Path
	dev-perl/File-ShareDir
	>=dev-perl/File-ShareDir-Install-0.30.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-pushd
	dev-perl/JSON-MaybeXS
	>=dev-perl/Log-Dispatchouli-1.102.220
	>=dev-perl/Mixin-Linewise-0.100.0
	virtual/perl-Module-CoreList
	dev-perl/Module-Runtime
	>=dev-perl/Moose-0.920.0
	dev-perl/MooseX-LazyRequire
	>=dev-perl/MooseX-Role-Parameterized-1.10.0
	dev-perl/MooseX-SetOnce
	dev-perl/MooseX-Types
	dev-perl/MooseX-Types-Perl
	dev-perl/PPI
	dev-perl/Params-Util
	>=dev-perl/Path-Tiny-0.52.0
	>=dev-perl/Perl-PrereqScanner-1.16.0
	>=dev-perl/Pod-Eventual-0.91.480
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/Software-License-0.101.370
	virtual/perl-Storable
	>=dev-perl/String-Formatter-0.100.680
	>=dev-perl/String-RewritePrefix-0.6.0
	dev-perl/Sub-Exporter
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/Term-Encoding
	dev-perl/TermReadKey
	virtual/perl-Term-ReadLine
	dev-perl/Term-UI
	dev-perl/Test-Deep
	>=dev-perl/Text-Glob-0.80.0
	dev-perl/Text-Template
	dev-perl/Try-Tiny
	dev-perl/YAML-Tiny
	virtual/perl-autodie
	dev-perl/namespace-autoclean
	virtual/perl-parent
	virtual/perl-version
"
# t: Software::License::None -> Software-License 0.016
# t: lib, utf8 -> perl
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		dev-perl/Test-FailWarnings
		dev-perl/Test-Fatal
		dev-perl/Test-File-ShareDir
		>=virtual/perl-Test-Simple-0.960.0
	)
"
src_test() {
	TZ=UTC perl-module_src_test
}
