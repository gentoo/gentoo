# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

MY_P="${P/_p/-}"

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${MY_P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-util/netsurf-buildsystem"

S="${WORKDIR}/${MY_P}"

_emake() {
	source "${EPREFIX}"/usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared "${@}"
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}
