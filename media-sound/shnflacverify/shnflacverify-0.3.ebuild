# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="This program helps manage the verification of checksums related to Shorten and FLAC files"
HOMEPAGE="https://sourceforge.net/projects/shnflacverify/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${P}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	app-arch/unzip
	media-libs/flac
	media-sound/shntool
	sys-apps/coreutils"

S="${WORKDIR}"

src_prepare() {
	local X
	edos2unix *.txt
	for X in flac md5sum shntool metaflac; do
		einfo "setting \$${X}_cmd to $(type -p ${X})"
		sed -i -e "s|^\(\$${X}_cmd\s*=\s*'\)[^']*\('.*\)|\1$(type -p ${X})\2|g" shnflac*
	done
}

src_install() {
	local X
	for X in *.pl; do newbin "${X}" "${X%.*}"; done
	newdoc README.txt README
}
