# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANIEL
DIST_VERSION=2.4
inherit perl-module

DESCRIPTION="Access to FLAC audio metadata"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="media-libs/flac:="
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.4-no-dot-inc.patch"
)

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
