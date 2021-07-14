# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/./-}
MY_P=HyperSpec-${MY_PV}

DESCRIPTION="Common Lisp ANSI-standard Hyperspec"
HOMEPAGE="http://www.lispworks.com/reference/HyperSpec/"
SRC_URI="ftp://ftp.lispworks.com/pub/software_tools/reference/${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="HyperSpec"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DOCS="HyperSpec*"
