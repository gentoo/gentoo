# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

MY_P="${PN}-el-${PV}"
DESCRIPTION="An Emacs Lisp interface to the MLDonkey core"
HOMEPAGE="https://www.emacswiki.org/emacs/MlDonkey
	http://web.archive.org/web/20070107165326/www.physik.fu-berlin.de/~dhansen/mldonkey/"
SRC_URI="http://www.physik.fu-berlin.de/%7Edhansen/mldonkey/files/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}/${MY_P}"
ELISP_PATCHES="${P}-vd.patch ${P}-emacs-26.patch"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="If your network gets really slow when you use mldonkey,
	consider reducing the max number of connections. See bug #50510.
	\n\nRemember to install net-p2p/mldonkey separately if you want to
	work with a local instance."

src_compile() {
	elisp-compile ml*.el
}
