# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/yandex-disk/yandex-disk-0.1.5.870_p1.ebuild,v 1.1 2015/03/25 12:18:24 pinkbyte Exp $

EAPI=5

inherit bash-completion-r1 eutils rpm

MY_P="${PN}-${PV/_p/-}"

DESCRIPTION="CLI to access Yandex Disk file storage service"
HOMEPAGE="https://disk.yandex.ru"
SRC_URI="
	amd64? ( http://repo.yandex.ru/yandex-disk/rpm/stable/x86_64/${MY_P}.fedora.x86_64.rpm )
	x86? ( http://repo.yandex.ru/yandex-disk/rpm/stable/i386/${MY_P}.fedora.i386.rpm )
"

LICENSE="YDSLA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND=""
RDEPEND="sys-libs/zlib"

S="${WORKDIR}"

QA_PREBUILT="opt/bin/yandex-disk"

src_prepare() {
	# bug #526312
	sed -i \
		-e '/have /d' \
		-e 's/+o nospace/-o nospace/' \
		-e '/^complete/s/-X //' \
		etc/bash_completion.d/yandex-disk-completion.bash || die

	epatch_user
}

src_install() {
	exeinto /opt/bin
	doexe usr/bin/yandex-disk
	newbashcomp etc/bash_completion.d/yandex-disk-completion.bash "${PN}"
}
