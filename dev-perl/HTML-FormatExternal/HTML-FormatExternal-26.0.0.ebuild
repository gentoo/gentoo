# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KRYDE
DIST_VERSION=26
inherit perl-module

DESCRIPTION="HTML to text formatting using external programs"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/IPC-Run
	dev-perl/URI
	dev-perl/constant-defer
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker
"

src_prepare() {
	# remove some test inputs that fail in w3m
	# https://bugs.gentoo.org/904076
	sed -i -e 's/-###/-/' t/FormatExternal.t || \
		die "Couldn't replace -### test input"
	sed -i -e 's/%57/-/' t/FormatExternal.t || \
		die "Couldn't replace %57 test input"

	eapply_user
}
