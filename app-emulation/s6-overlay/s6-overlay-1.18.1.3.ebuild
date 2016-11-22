# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/just-containers/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/just-containers/${PN}/archive/v${PV}.tar.gz ->
	${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit vcs-snapshot
fi

DESCRIPTION="an s6-based init system for containers"
HOMEPAGE="https://github.com/just-containers/s6-overlay"

LICENSE="ISC"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/s6
	sys-apps/s6-portable-utils"

src_install() {
	dodoc *.md
	cd builder/overlay-rootfs
	dobin usr/bin/{fix-attrs,logutil*,print*,with*}

	insinto /
	doins -r etc init

	# create must exist directories
	dodir /etc/{cont-init.d,cont-finish.d,fix-attrs.d,services.d}
	dodir /etc/s6/init/env-stage2

	# create "supervise" directory in fdholder, its needed for no-catchall
	# stage2 wake up
	dodir /etc/s6/services/s6-fdholderd/supervise
	fperms 0700 /etc/s6/services/s6-fdholderd/supervise

	# fix misc permissions
	fperms 0755 /init
	fperms 0755 /etc/s6/init/init-stage1 \
		/etc/s6/init/init-stage2 \
		/etc/s6/init/init-stage2-redirfd \
		/etc/s6/init/init-stage3
	fperms 0755 /etc/s6/init-catchall/init-stage1 \
		/etc/s6/init-catchall/init-stage2
	fperms 0755 /etc/s6/init-no-catchall/init-stage1 \
		/etc/s6/init-no-catchall/init-stage2
	fperms 0755 /etc/s6/services/.s6-svscan/crash
	fperms 0755 /etc/s6/services/.s6-svscan/finish
	fperms 0755 /etc/s6/services/s6-fdholderd/run
	fperms 0755 /etc/s6/services/s6-svscan-log/run
}
