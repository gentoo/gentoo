# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wine-compholio/wine-staging"
	KEYWORDS=""
else
	SHA="4ffcf184bb71c6c3512b3a8c144dcf4a3a76d23c"
	SRC_URI="https://github.com/wine-compholio/wine-staging/archive/${SHA}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~x86-fbsd"
	S="${WORKDIR}/wine-staging-${SHA}"
fi

DESCRIPTION="Apply binary patches without git"
HOMEPAGE="https://github.com/wine-compholio/wine-staging"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="userland_BSD userland_GNU"

RDEPEND="
	app-shells/bash
	sys-apps/coreutils
	sys-apps/gawk
	sys-apps/grep
	userland_BSD? (
		sys-freebsd/freebsd-bin
		sys-freebsd/freebsd-ubin
	)
	userland_GNU? (
		sys-apps/util-linux
		sys-devel/patch
	)
"

src_prepare(){
	mv patches/gitapply.sh ${PN} || die
	sed -E -i "s/(\.\/)?gitapply(\.sh)?/${PN}/g" ${PN} || die

	default
}

src_install(){
	exeinto /usr/bin/
	doexe ${PN}
}

pkg_postinst(){
	einfo "${PN} can optionally use dev-util/git to apply patches if installed."
}
