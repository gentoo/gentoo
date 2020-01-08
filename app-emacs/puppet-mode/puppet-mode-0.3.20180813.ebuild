# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

COMMIT=7dee1b5a5debac6e56f9107492a413b6c0edb94d

DESCRIPTION="Emacs major mode for editing Puppet manifests"
HOMEPAGE="https://github.com/voxpupuli/puppet-mode"
SRC_URI="https://github.com/voxpupuli/puppet-mode/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"

DOCS="CHANGES.md README.md"
SITEFILE="50${PN}-1-gentoo.el"

# Tests require unpackaged ert-runner
RESTRICT="test"

src_prepare() {
	elisp_src_prepare

	sed -i -e 's/@VERSION@/'${PV}'/' puppet-mode.el || die
}
