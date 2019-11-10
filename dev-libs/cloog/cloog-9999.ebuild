# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://repo.or.cz/cloog.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="http://www.bastoul.net/cloog/pages/download/${P}.tar.gz"
fi

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/"

LICENSE="LGPL-2.1"
SLOT="0/4"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-6.0.0[${MULTILIB_USEDEP}]
	>=dev-libs/isl-0.15:0=[${MULTILIB_USEDEP}]"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( README )

src_prepare() {
	default

	if [[ ${PV} == "9999" ]] ; then
		./get_submodules.sh
		eautoreconf -i
	else
		# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
		# sed to avoid eautoreconf
		sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die
	fi

	# Make sure we always use the system isl.
	rm -rf isl
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-gmp=system \
		--with-isl=system \
		--with-osl=no \
		$(use_enable static-libs static)
}

# The default src_test() fails, so we'll just run these directly
multilib_src_test () {
	echo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	emake -j1 check
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete
}
