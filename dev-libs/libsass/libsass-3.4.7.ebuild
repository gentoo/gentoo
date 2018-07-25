# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils ltprune multilib-minimal

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/sass/libsass.git"
	inherit git-r3
	KEYWORDS=
else
	SRC_URI="https://github.com/sass/libsass/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~amd64-linux"
fi

DESCRIPTION="A C/C++ implementation of a Sass CSS compiler"
HOMEPAGE="https://github.com/sass/libsass"
LICENSE="MIT"
SLOT="0/0" # libsass soname
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS=( Readme.md SECURITY.md )

src_prepare() {
	default

	if [[ ${PV} != *9999 ]]; then
		[[ -f VERSION ]] || echo "${PV}" > VERSION
	fi
	eautoreconf

	# only sane way to deal with various version-related scripts, env variables etc.
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-shared
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}

multilib_src_install_all() {
	einstalldocs
	dodoc -r "${S}/docs"
}
