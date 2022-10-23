# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage active wine version"
HOMEPAGE="https://bitbucket.org/NP-Hardass/eselect-wine"
SRC_URI="https://bitbucket.org/NP-Hardass/eselect-wine/get/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/NP-Hardass-eselect-wine-f18b76f9c90c"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 x86"

RDEPEND="
	app-admin/eselect
	dev-util/desktop-file-utils"

PATCHES=(
	"${FILESDIR}"/${P}-proton.patch
)

src_install() {
	insinto /usr/share/eselect/modules
	doins wine.eselect

	keepdir /etc/eselect/wine
}

pkg_postinst() {
	# <eselect-wine-v0.3_rc7 installed symlinks with leading double-slashes.
	# In /usr/include this breaks gcc build.
	# https://bugs.gentoo.org/434180
	if [[ $(readlink "${EROOT}"/usr/include/wine) == //* ]]; then
		ewarn "Leading double slash in ${EROOT}/usr/include/wine symlink detected."
		ewarn "Re-setting wine symlinks..."
		eselect wine update --if-unset
	fi
}

pkg_prerm() {
	# Avoid conflicts with wine[-multislot] installed later
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		elog "${PN} is being uninstalled, removing symlinks"
		eselect wine unset --all || die
	else
		einfo "${PN} is being updated/reinstalled, not modifying symlinks"
	fi
}
