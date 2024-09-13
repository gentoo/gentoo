# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == "1.11.1" ]] && COMMIT="7febe164de2a881b83b9d604d3c7cf20b69f422d"

inherit elisp readme.gentoo-r1 optfeature

DESCRIPTION="Emacs Interface to XClip"
HOMEPAGE="https://elpa.gnu.org/packages/xclip.html"
SRC_URI="https://git.savannah.gnu.org/gitweb/?p=emacs/elpa.git;a=snapshot;h=${COMMIT};sf=tgz
	-> ${P}.tar.gz"
S="${WORKDIR}/elpa-${COMMIT:0:7}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOC_CONTENTS="To enable xclip-mode, add (xclip-mode 1) to your ~/.emacs file."
SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp_pkg_postinst

	optfeature "X11 clipboard support" x11-misc/xclip x11-misc/xsel
	optfeature "Wayland clipboard support" gui-apps/wl-clipboard
}
