# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Remote EXexcution agent"
HOMEPAGE="http://mduft.github.io/rex/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mduft/rex.git"
else
	SRC_URI=""
	KEYWORDS="~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

REX_EXE=(
	"client/rex-exec.sh"
	"client/rex-register.sh"
	"client/rex-paths.sh"
	"client/rex-remote-pconv.sh"
	"client/winpath2unix"
	"client/unixpath2win"
	)

src_prepare() {
	for x in ${REX_EXE[@]}; do
		sed \
			-e "s,\. \${HOME}/rex-config.sh,\. ${EPREFIX}/etc/rex.conf,g" \
			-i "${x}" || die
	done
}

src_install() {
	for x in ${REX_EXE[@]}; do
		dobin "${S}"/${x}
	done

	insinto /etc
	newins client/rex-config.sh rex.conf
}
