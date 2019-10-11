# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="https://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-libs/libxml2[python,${PYTHON_USEDEP}]')
	dev-libs/libxslt
	sys-devel/gettext
"

src_configure() {
	econf --without-gimp
}

src_compile() {
	# see https://bugs.gentoo.org/677198
	emake -j 1
}
