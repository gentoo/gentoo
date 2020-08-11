# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib toolchain-funcs portability flag-o-matic multilib-minimal

MY_PN=${PN/-/_}
MY_P=${MY_PN}_${PV}

DESCRIPTION="The Linux Audio Developer's Simple Plugin API"
HOMEPAGE="http://www.ladspa.org/"
SRC_URI="http://www.ladspa.org/download/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-properbuild.patch"
)

HTML_DOCS="doc/*.html"

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_compile() {
	cd src
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		DYNAMIC_LD_LIBS="$(dlopen_lib)" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		targets
}

multilib_src_test() {
	cd src
	emake test
}

multilib_src_install() {
	cd src
	emake INSTALL_PLUGINS_DIR="/usr/$(get_libdir)/ladspa" \
		DESTDIR="${ED}" \
		MKDIR_P="mkdir -p" \
		install
}

multilib_src_install_all() {
	einstalldocs

	# Needed for apps like rezound
	dodir /etc/env.d
	echo "LADSPA_PATH=${EPREFIX}/usr/$(get_libdir)/ladspa" > "${ED}/etc/env.d/60ladspa"
}
