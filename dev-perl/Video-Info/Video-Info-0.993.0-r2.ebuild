# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALLENDAY
DIST_VERSION=0.993
inherit perl-module

DESCRIPTION="Perl extension for getting video info"

LICENSE="Aladdin"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Class-MakeMethods"
DEPEND="${RDEPEND}
	test? (
		dev-perl/MP3-Info
	)
"
PERL_RM_FILES=(
	# Can't be bothered packaging both Video::OpenQuicktime and libopenquicktime
	"t/Quicktime.t"
	# Broken, TODO: Work out what's wrong
	"t/MPEG.t"
)
