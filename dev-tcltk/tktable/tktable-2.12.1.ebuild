# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=${PN}-$(ver_rs 1- '-')

DESCRIPTION="full-featured 2D table widget"
HOMEPAGE="http://tktable.sourceforge.net/"
SRC_URI="https://github.com/bohagan1/TkTable/archive/refs/tags/${MYP}.tar.gz"

S=${WORKDIR}/TkTable-${MYP}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/tk-8.0:="
RDEPEND="${DEPEND}"

HTML_DOCS=( doc/tkTable.html )
DOCS=( ChangeLog README.txt )

QA_CONFIG_IMPL_DECL_SKIP=(
	opendir64 rewinddir64 closedir64 stat64 # used on AIX
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.10-parallelMake.patch
)

src_prepare() {
	default
	sed -e '/^install:/{s: install-doc-n::}' \
		-e '/^PKG_EXTRA_FILES/{s:=.*:=:}' -i Makefile.in || die
}
