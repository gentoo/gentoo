# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="checkpassword-compatible authentication program w/pam support"
HOMEPAGE="http://checkpasswd-pam.sourceforge.net/"
SRC_URI="mirror://sourceforge/checkpasswd-pam/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm64 hppa ppc x86"

DEPEND=">=sys-libs/pam-0.75"

DOCS=(
	AUTHORS
	NEWS
	README
)
