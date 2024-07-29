# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix

DESCRIPTION="Manage the verification of checksums related to Shorten and FLAC files"
HOMEPAGE="https://sourceforge.net/projects/shnflacverify/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${P}/${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="
	dev-lang/perl
	media-libs/flac
	media-sound/shntool
	sys-apps/coreutils
"

src_prepare() {
	default

	edos2unix *.txt

	local X
	for X in flac md5sum shntool metaflac; do
		einfo "setting \$${X}_cmd to $(type -p ${X})"
		sed -i -e "s|^\(\$${X}_cmd\s*=\s*'\)[^']*\('.*\)|\1$(type -p ${X})\2|g" shnflac* || die
	done
}

src_install() {
	local X
	for X in *.pl; do newbin "${X}" "${X%.*}"; done
	newdoc README.txt README
}
