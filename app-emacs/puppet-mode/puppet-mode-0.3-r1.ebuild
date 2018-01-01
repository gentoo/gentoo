# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Emacs major mode for editing Puppet manifests"
HOMEPAGE="https://github.com/voxpupuli/puppet-mode"
SRC_URI="https://github.com/voxpupuli/puppet-mode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"

DOCS="CHANGES.rst README.rst"
SITEFILE="50${PN}-1-gentoo.el"
ELISP_PATCHES=( "${FILESDIR}/${PN}-0.3-version.patch" )

src_prepare() {
	elisp_src_prepare

	sed -i -e 's/@VERSION@/'${PV}'/' puppet-mode.el || die
}
