# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ASOKOLOV
DIST_VERSION=9
DIST_TEST=do
inherit perl-module virtualx

DESCRIPTION="Image viewer widget for Gtk3"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Cairo
	>=dev-perl/glib-perl-1.210.0
	dev-perl/Gtk3
	dev-perl/Readonly
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Carp-Always
		dev-perl/Test-Differences
		dev-perl/Test-MockObject
		dev-perl/Try-Tiny
		media-gfx/imagemagick[jpeg,perl,png,svg,X]
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	t/90_MANIFEST.t
	t/91_critic.t
)

src_test() {
	virtx perl-module_src_test
}
