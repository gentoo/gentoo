# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6,7} )
inherit gnome2-utils meson python-single-r1 virtualx xdg-utils

DESCRIPTION="Two-factor authentication code generator for GNOME"
HOMEPAGE="https://gitlab.gnome.org/World/Authenticator"

# Commit that this version of Authenticator references from its libgd submodule.
GNOME_LIBGD_COMMIT="7ae254bfc5f641c60566614e08245176f7bc5aa8"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="${HOMEPAGE}"
else
	SRC_URI="https://gitlab.gnome.org/World/Authenticator/-/archive/${PV}/Authenticator-${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/GNOME/libgd/archive/${GNOME_LIBGD_COMMIT}.tar.gz -> ${P}-libgd-${GNOME_LIBGD_COMMIT}.tar.gz"
	S="${WORKDIR}/Authenticator-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-crypt/libsecret
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyotp[${PYTHON_USEDEP}]
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	dev-python/pyzbar[${PYTHON_USEDEP}]
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "1s:#!/usr/bin/env python3:#!${PYTHON}:" "authenticator.py.in" || die "Could not fix shebang."

	rm -r "subprojects/libgd" || die "Could not remove the subproject libgd folder."
	ln -s "../../libgd-${GNOME_LIBGD_COMMIT}" "subprojects/libgd" || die "Could not symlink libgd subproject."
}

src_test() {
	xdg_environment_reset
	virtx meson_src_test
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
