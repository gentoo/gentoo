# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DANIEL
DIST_VERSION=1.0
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Object-oriented interface to Ogg Vorbis information and comment fields"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.0-test-array-ref.patch"
	"${FILESDIR}/${PN}-1.0-example-ogginfo.patch"
)
