# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="
	https://ncdu.landless-city.net
	https://github.com/BratishkaErik/ncdu
"
SRC_URI="
	amd64? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-x86_64.tar.gz )
	arm? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-arm.tar.gz )
	arm64? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-aarch64.tar.gz )
	x86? ( https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/ncdu-${PV}-linux-x86.tar.gz )
	https://raw.githubusercontent.com/BratishkaErik/ncdu/refs/tags/v${PV}/ncdu.1 -> ncdu-${PV}.man
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
IUSE="+symlink"

RDEPEND="symlink? ( !sys-fs/ncdu )"

QA_PREBUILT="usr/bin/ncdu-bin"

src_install() {
	newbin ncdu ncdu-bin
	newman "${DISTDIR}/ncdu-${PV}.man" ncdu-bin.1

	if use symlink ; then
		dosym ncdu-bin /usr/bin/ncdu
		dosym ncdu-bin.1 /usr/share/man/man1/ncdu.1
	fi
}
