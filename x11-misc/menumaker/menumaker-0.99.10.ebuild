# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit autotools python-r1

DESCRIPTION="Utility that scans through the system and generates a menu of installed programs"
HOMEPAGE="http://menumaker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE="doc"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.99.10-AM_PATH_PYTHON.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	configure() {
		ECONF_SOURCE="${S}" econf PYTHON="${EPYTHON}"
	}
	python_foreach_impl run_in_build_dir configure
}

src_compile() {
	compile() {
		default
		use doc && emake html
	}
	python_foreach_impl run_in_build_dir compile
}

src_install() {
	compile() {
		default
		use doc && emake DESTDIR="${D}" install-html
	}
	python_foreach_impl run_in_build_dir compile
	python_replicate_script "${ED%/}"/usr/bin/mmaker
	einstalldocs
}
