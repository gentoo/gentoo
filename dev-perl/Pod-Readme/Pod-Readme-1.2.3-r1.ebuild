# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=v1.2.3
inherit perl-module

DESCRIPTION="Intelligently generate a README file from POD"

SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/Pod-Markdown
		dev-perl/Pod-Markdown-Github
		dev-perl/Pod-Simple-LaTeX
		dev-perl/Type-Tiny-XS
	)
	>=dev-perl/CPAN-Changes-0.300.0
	dev-perl/Class-Method-Modifiers
	dev-perl/File-Slurp
	dev-perl/Getopt-Long-Descriptive
	dev-perl/Moo
	dev-perl/MooX-HandlesVia
	dev-perl/Path-Tiny
	dev-perl/Role-Tiny
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Try-Tiny
	>=dev-perl/Type-Tiny-1.0.0
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/IO-String
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Kit
	)
"
PERL_RM_FILES=(
	"t/author-clean-namespaces.t"
	"t/author-critic.t"
	"t/author-eof.t"
	"t/author-eol.t"
	"t/author-minimum-version.t"
	"t/author-no-tabs.t"
	"t/author-pod-syntax.t"
	"t/author-portability.t"
	"t/release-check-manifest.t"
	"t/release-fixme.t"
	"t/release-kwalitee.t"
	"t/release-trailing-space.t"
)
