# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities for Enhanced Motif Window Manager (EMWM)"
HOMEPAGE="https://fastestcode.org/emwm.html"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/alx210/mwm-utils.git"
	inherit git-r3
else
	SRC_URI="https://fastestcode.org/dl/emwm-utils-src-${PV}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-src-${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	${BDEPEND}
	>=x11-libs/libX11-1.6.2
	x11-libs/libXScrnSaver
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXt
	x11-libs/motif
	virtual/libcrypt:=
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-misc/xbitmaps
"

src_install() {
	# Upstream doesn't honour DESTDIR but it's only a few files anyway...
	# set SUID, required for screen locking
	for binary in xmsession xmsm xmtoolbox ; do
		dobin "src/${binary}"
		if ! [[ "${binary}" == "xmsession" ]]; then
			doman "src/${binary}.1"
		fi
	done
	fperms 4775 /usr/bin/xmsm

	insinto /etc/X11/app-defaults
	for file in XmSm XmToolbox; do
		newins "src/${file}.ad" "${file}"
	done

	insinto /etc/X11
	doins src/toolboxrc
}
