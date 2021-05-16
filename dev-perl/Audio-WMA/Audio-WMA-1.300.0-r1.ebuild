# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=1.3
DIST_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="extension for reading WMA/ASF metadata"

SLOT="0"
KEYWORDS="~amd64 ~x86"

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
PATCHES=(
	"${FILESDIR}/${PN}-1.3-no-dot-inc.patch"
)
