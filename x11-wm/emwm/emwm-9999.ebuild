# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Enhanced Motif Window Manager (MWM fork)"
HOMEPAGE="https://fastestcode.org/emwm.html"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/alx210/emwm.git"
	inherit git-r3
else
	SRC_URI="https://fastestcode.org/dl/emwm-src-${PV}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-src-${PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXext-1.3.2
	x11-libs/libXinerama
	x11-libs/libXrandr
	>=x11-libs/libXt-1.1.4
	x11-libs/motif
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	# Upstream unconditionally sets CFLAGS; let's use the ones from portage instead
	sed -i "s/CFLAGS = -O2 -Wall \$(INCDIRS)/CFLAGS+= \$(INCDIRS)/" mf/Makefile.Linux || die
	default
}

src_install() {
	# Upstream doesn't honour DESTDIR but it's only a few files
	dobin src/emwm
	doman src/emwm.1

	insinto /etc/X11
	doins src/system.emwmrc

	insinto /etc/X11/app-defaults
	newins src/Emwm.ad Emwm
}

pkg_postinst() {
	optfeature "EMWM utilities" x11-misc/emwm-utils
}
