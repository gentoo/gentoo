# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P=linux-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Developer documentation generated from the Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v3.x/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE=""
DEPEND="dev-python/sphinx"
RDEPEND=""

src_compile() {
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT
	emake htmldocs
}

src_install() {
	HTML_DOCS=( Documentation/output/. )
	einstalldocs
}
