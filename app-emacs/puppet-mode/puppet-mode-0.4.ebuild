# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Emacs major mode for editing Puppet manifests"
HOMEPAGE="https://github.com/voxpupuli/puppet-mode"
SRC_URI="https://github.com/voxpupuli/puppet-mode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"

DOCS="CHANGES.md README.md"
SITEFILE="50${PN}-1-gentoo.el"

# Tests require unpackaged ert-runner
RESTRICT="test"

src_prepare() {
	elisp_src_prepare

	sed -i -e 's/@VERSION@/'${PV}'/' puppet-mode.el || die
}
