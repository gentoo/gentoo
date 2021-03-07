# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-multilib

MY_P="deviceatlas-enterprise-c-${PV/_p/_}"

DESCRIPTION="API to detect devices based on the User-Agent HTTP header"
HOMEPAGE="https://deviceatlas.com"
SRC_URI="${MY_P}.tgz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc examples"

RDEPEND="dev-libs/libpcre[${MULTILIB_USEDEP}]"
DEPEND="
	${RDEPEND}"

RESTRICT="fetch mirror bindist"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PV}-src-cmakelists.patch"
)

pkg_nofetch() {
	eerror "Please go to https://deviceatlas.com/deviceatlas-haproxy-module"
	eerror "And download DeviceAtlas C API"
	eerror "Save the file as ${MY_P}.tgz in your DISTDIR directory."
}

multilib_src_install_all() {
	if use doc; then
		local -a HTML_DOCS=( Documentation )
	fi

	if use examples; then
		docinto examples
		dodoc -r Examples/.
	fi

	einstalldocs
}
