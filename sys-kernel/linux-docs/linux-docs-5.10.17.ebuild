# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8,9} )
inherit python-any-r1 toolchain-funcs

MY_PV="$(ver_cut 1-2)"
MY_P=linux-${MY_PV}

S=${WORKDIR}/${MY_P}

DESCRIPTION="Developer documentation generated from the Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v5.x/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86"

IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND="${PYTHON_DEPS}
	dev-python/sphinx
	dev-python/sphinx_rtd_theme
	media-libs/fontconfig"

src_prepare() {
	default
	# Fix the Python shebangs.
	python_fix_shebang "${S}/Documentation/sphinx/"
}

src_compile() {
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT
	HTML_DOCS=( Documentation/output/. )
	emake htmldocs
}

src_install() {
	einstalldocs
}
