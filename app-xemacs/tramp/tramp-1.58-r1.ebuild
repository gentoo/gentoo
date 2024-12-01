# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Remote shell-based file editing"
SRC_URI="https://dev.gentoo.org/~matsl/${P}-repackaged-pkg.tar.gz"
SLOT="0"
XEMACS_PKG_CAT="standard"

XEMACS_EXPERIMENTAL="true"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/vc
app-xemacs/efs
app-xemacs/dired
app-xemacs/mail-lib
app-xemacs/gnus
app-xemacs/ediff
app-xemacs/sh-script
app-xemacs/edebug
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

inherit xemacs-packages
